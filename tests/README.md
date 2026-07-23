# Testing & validation

This repo renders Helm charts into ArgoCD `Application` objects, and ArgoCD then
installs the real upstream charts. That indirection means a values mistake is
invisible to a normal `helm template` of this repo — it only breaks at ArgoCD
sync time. The checks here exist to catch those mistakes in CI instead.

There are **two layers**, plus the pre-existing kubeconform check.

| Layer | What it validates | Where it lives | When it runs |
|-------|-------------------|----------------|--------------|
| kubeconform | The **outer** ArgoCD `Application` objects (the wrappers) | `render-validate-helm.yaml` (`helm-render`) | every PR + push |
| helm-unittest | The **shape** of each rendered Application (name, project, source coords, destination, syncPolicy, enable guards, `required` contracts) + a full snapshot | `stable/*/**/tests/*_test.yaml` | every PR + push |
| inner-values validator | The **inline `helm.values`** rendered against the **real upstream chart** (schema + template errors) | `tests/validate-inner-values.sh` | PR (vetted subset / all on Renovate PRs) + nightly (all) |

Key point: kubeconform only sees the Application wrapper. It cannot see inside
the `spec.source.helm.values` string. That string — the upstream chart's real
config — is what the inner-values validator checks.

## Prerequisites (local)

Pinned to the versions CI uses (see the `env:` block in the workflows). Matching
the helm version matters: snapshots encode helm's exact YAML serialization.

- helm `v3.19.2`
- yq (mikefarah) `v4.47.2`
- helm-unittest plugin `1.1.1` — `helm plugin install https://github.com/helm-unittest/helm-unittest --version 1.1.1`
- kubeconform `v0.6.0` (only needed to reproduce the outer CI check)

## Running the checks

```bash
# Outer-shape unit tests (fast, offline). Auto-discovers any chart with a tests/ dir.
helm unittest -f 'tests/*_test.yaml' stable/aurora-platform/charts/aurora-core

# Inner-values validation (pulls upstream charts; needs network).
tests/validate-inner-values.sh cert-manager            # one or more components
tests/validate-inner-values.sh                         # entire fleet (slow, ~several min)
tests/validate-inner-values.sh --help                  # usage
```

The inner-values validator renders the umbrella chart with `config/config.yaml`,
then for every Application that sources a Helm chart it runs
`helm template <chart> --repo <repo> --version <rev> -f <inline values>` against
the real upstream chart. Applications that ship no inline values are rendered
with chart defaults (shown as `(defaults)`) to confirm the chart/version
resolves. Git- and OCI-sourced Applications are out of scope.

## Upgrading a chart / adding new values

Worked example: cert-manager `v1.20.3` -> `v1.21.0`, adding `enableGatewayAPI: true`.

1. **Edit the component template** (`.../templates/cert-manager/cert-manager.yaml`):
   - Bump the `targetRevision` default (`v1.20.3` -> `v1.21.0`).
   - Add the new key inside the `values: |` block. Mind indentation — it is the
     upstream chart's values, injected with `nindent`.
   - If the value should be configurable, add a default under
     `.Values.components.certManager` in the subchart `values.yaml` and template it in.

2. **Validate the new values against the new chart** (the important step):
   ```bash
   tests/validate-inner-values.sh cert-manager
   ```
   This pulls v1.21.0 and checks your values against it. If the key is misspelled,
   removed/renamed upstream, or the wrong type — and the chart ships a
   `values.schema.json` (cert-manager does) — this fails here instead of at sync.

3. **Update the unit-test assertion** for the pinned version in
   `tests/cert-manager_test.yaml` (`targetRevision: v1.20.3` -> `v1.21.0`).

4. **Regenerate and review the snapshot**:
   ```bash
   helm unittest -u -f 'tests/cert-manager_test.yaml' stable/aurora-platform/charts/aurora-core
   ```
   The `-u` regenerates the committed `.snap`. **Read the diff.** It should show
   only the version bump and your new value line. Anything else is a signal.

5. **Confirm green and commit**:
   ```bash
   helm unittest -f 'tests/*_test.yaml' stable/aurora-platform/charts/aurora-core
   ```

CI then re-runs all layers on the PR; the nightly job re-validates the full fleet.

## Adding a unit test for a new component

Copy an existing `*_test.yaml` in the chart's `tests/` dir and adjust:

- `templates:` -> the component's primary Application template.
- suite-level `set:` -> the minimum inputs to render it (`global.cluster`,
  `global.project`, the component `enabled`, and any `required` fields).
- Assert `metadata.name`, `spec.project`, `spec.source.{chart,repoURL,targetRevision}`,
  `spec.destination.namespace`, and `spec.syncPolicy`.
- Add an enable-guard test (`enabled: false` -> `hasDocuments: count: 0`) if the
  template has a guard.
- Add a `failedTemplate` test (with `errorPattern`) for each `required` field.
- Generate the snapshot with `helm unittest -u` and review before committing.

The helm-unittest CI job auto-discovers any chart directory containing a `tests/`
folder, so no workflow change is needed to pick up new suites.

## Snapshots: keep them honest

Snapshots only guard against regressions if they are committed **and** their
diffs are actually reviewed. Regenerating with `-u` without reading the diff
turns them into rubber stamps. If a snapshot's noise ever outweighs its value,
drop the `matchSnapshot` assertion and rely on the explicit `equal`/`matchRegex`
assertions plus the inner-values validator.

## Renovate

Renovate opens PRs that bump `targetRevision` in the component templates. Such a
PR will:

- **Fail helm-unittest** (the `targetRevision` assertion and the snapshot) until
  you update the assertion and regenerate the snapshot — this is deliberate, so
  the upgrade gets a human review.
- **Trigger a full-fleet inner-values run** (the CI job validates *all*
  components on `renovate/*` PRs, not just the vetted subset), so the bumped
  chart's values are checked against the new version automatically.

Note: teaching Renovate to *find* the versions embedded in Go-templated
`targetRevision:` lines requires a Renovate custom regex manager — that is
Renovate configuration, separate from these tests.

## Known gaps

- Charts without a `values.schema.json`: the inner validator only catches YAML
  and type errors, not well-formed-but-nonexistent keys.
- Values passed via `spec.source.plugin` (AVP) rather than `spec.source.helm`
  (e.g. cert-manager issuers) are not schema-checked by the inner validator.
- Git- and OCI-sourced Applications are not covered.
- The embedded Kubernetes resources inside `raw`-chart values are rendered but
  not currently schema-checked (kubeconform runs only on the outer render).
