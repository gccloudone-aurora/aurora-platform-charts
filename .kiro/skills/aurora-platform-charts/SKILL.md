---
name: aurora-platform-charts
description: >-
  Expert guidance for working in the aurora-platform-charts repo: a curated set
  of CNCF platform components packaged as Helm charts that render ArgoCD
  Application manifests, which in turn deploy the real upstream Helm charts.
  Use this skill whenever adding, modifying, debugging, versioning, validating,
  or reviewing charts, components, or ArgoCD Applications in this repo.
---

# Aurora Platform Charts

This repo (`aurora-platform-charts`) oversees deployment of every platform
component for the Aurora platform. It is a Helm chart repository, but the charts
almost never deploy Kubernetes workloads directly. Instead they render **ArgoCD
`Application` resources**, and ArgoCD reconciles those Applications by pulling
and installing the *real* upstream Helm charts onto target clusters.

Understanding this three-layer indirection is the single most important thing
when working here.

## The core mental model: Helm renders ArgoCD, ArgoCD runs Helm

```
config/config.yaml (or a project's config.yaml)
        │  helm values
        ▼
stable/aurora-platform  (umbrella Helm chart)
        │  subcharts: core / app / mgmt
        ▼
templates/<component>/<component>.yaml
        │  renders  ──►  kind: Application (argoproj.io/v1alpha1)
        ▼
ArgoCD reconciles the Application
        │  spec.source = { chart, repoURL, targetRevision, helm.values }
        ▼
Upstream Helm chart (e.g. jetstack/cert-manager) installed on the cluster
```

Key consequence: **`helm template stable/aurora-platform` outputs ArgoCD
`Application` manifests, not final Kubernetes objects.** The upstream chart's
resources only materialize once ArgoCD processes the Application on a live
cluster. Do not expect Deployments/DaemonSets/etc. in the rendered output.

## Repository layout

```
config/config.yaml              Reference values file (copied from project-aurora-template).
                                Toggles components via `enabled:` and injects secrets via
                                ArgoCD Vault Plugin `<path:...>` references.
scripts/generate-readme.sh      Regenerates the auto-managed charts section of the root README.
scripts/run-helm-docs.sh        Runs helm-docs per chart (uses each chart's README.md.gotmpl).
.github/workflows/              CI: render+validate, version bump, chart release.
stable/                         All published charts live here.
  aurora-platform/              THE umbrella chart. Everything flows through here.
    Chart.yaml                  Auto-bumped version; depends on core/app/mgmt (aliased).
    values.yaml                 Safe defaults; components off unless enabled.
    charts/
      aurora-core/              Core platform components (cert-manager, cilium, falco, ...).
      aurora-app/               Application-tier components (istio, elastic, strimzi, ...).
      aurora-mgmt/              Management components (argo-foundation, argo-solution, loki, ...).
        templates/<component>/  Each dir renders one ArgoCD Application (+ netpol, rbac, ns...).
  argocd-instance/              Standalone chart: configures an ArgoCD instance (ArgoCD CRD).
  argocd-operator/              Standalone chart: deploys the ArgoCD operator (+ CRDs).
  aurora-namespace/             Standalone chart: provisions a namespace (depends on `raw`).
  aurora-solution/              Standalone chart: solution-level resources.
  istio-ingress-gateway/        Standalone chart: opinionated Istio gateway (dep: upstream gateway).
  istio-custom-responses/       Standalone chart: Istio custom response templates.
  raw/                          Catch-all for arbitrary Kubernetes resources.
```

The three subcharts are aliased in `stable/aurora-platform/Chart.yaml`:

- `aurora-core`  → alias `core`  (gated by `core.enabled`)
- `aurora-app`   → alias `app`   (gated by `app.enabled`)
- `aurora-mgmt`  → alias `mgmt`  (gated by `mgmt.enabled`)

So a value at `core.components.certManager.enabled` in `config.yaml` maps to
`.Values.components.certManager.enabled` *inside the aurora-core subchart*.

## Anatomy of a component (the Application wrapper pattern)

Each component lives in `charts/<subchart>/templates/<component>/` and typically
contains:

- `<component>.yaml` — the ArgoCD `Application` (the heart of the component).
- `_helpers.tpl`     — named templates, usually image construction + workload-identity annotations.
- `namespace.yaml`, `netpol.yaml`, `rbac.yaml`, `alerts.yaml`, `issuers.yaml` — supporting resources rendered alongside.

The Application template follows a consistent shape (from `cert-manager.yaml`):

```yaml
{{ if .Values.components.certManager.enabled -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: "{{ .Values.global.cluster }}-cert-manager"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: {{ .Values.global.project }}
  source:
    chart: {{ default "cert-manager" .Values.components.certManager.helm.chart }}
    {{- if .Values.components.certManager.helm.repository }}
    repoURL: {{ .Values.components.certManager.helm.repository }}
    {{- else }}
    repoURL: {{ default "https://charts.jetstack.io" .Values.global.helm.repository }}
    {{- end }}
    targetRevision: {{ default "v1.20.3" .Values.components.certManager.helm.targetRevision }}
    helm:
      releaseName: cert-manager
      values: |
        # inline values passed to the UPSTREAM chart
        ...
  destination:
    name: {{ .Values.global.cluster }}
    namespace: cert-manager-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
{{- end }}
```

Conventions to preserve when editing or adding components:

- **Enable guard**: wrap the whole file in `{{ if .Values.components.<name>.enabled -}} ... {{- end }}`.
- **Application name**: `"{{ .Values.global.cluster }}-<component>"`.
- **Finalizer**: keep `resources-finalizer.argocd.argoproj.io`.
- **project**: `{{ .Values.global.project }}` (e.g. `aurora-core`).
- **Chart source precedence for repoURL**: per-component `helm.repository` overrides
  `global.helm.repository`, which falls back to a hardcoded upstream default.
  Mirror this three-tier `default`/`if` pattern for `chart` and `targetRevision`.
- **Pinned upstream version**: `targetRevision` carries the upstream chart version as the
  hardcoded default (e.g. `v1.20.3`). Bump this to upgrade the upstream component.
- **Inline `helm.values: |`**: this block is the upstream chart's values, not this repo's.
  Watch indentation carefully — values are injected with `nindent` at the block's indent level.
- **destination.namespace**: components install into their own `*-system` namespace by convention.
- **syncPolicy**: automated prune + selfHeal is the default.
- **Image helpers**: `_helpers.tpl` builds `repository`/`tag`/`pullPolicy` and honors
  `global.container.registry` as a fallback registry. Reuse `include "<comp>.image" .`.
- **Workload identity (Azure)**: helpers emit `azure.workload.identity/client-id` annotations
  and `azure.workload.identity/use: "true"` pod labels, gated by `workloadIdentity.enabled`.

## config.yaml vs values.yaml

- `stable/*/values.yaml` are **safe defaults**. In the umbrella chart, `app` and `mgmt`
  are `enabled: false` and `components: {}` by default; `core.enabled: true`.
- `config/config.yaml` is a **realistic deployment example** taken from
  `project-aurora-template`. It is what a consuming project supplies as Helm values.
  It uses two placeholder styles:
  - `<FILLIN_...>` — must be replaced with environment-specific literals before deploy.
  - `<path:VAULT#key>` / `<path:... | base64encode>` — **ArgoCD Vault Plugin (AVP)**
    references resolved at sync time from Azure Key Vault. Never hardcode these secrets.
- Component structure under `core|app|mgmt.components.<name>` mirrors the subchart's
  `.Values.components.<name>`. `global.*` in config maps to each subchart's `.Values.global`.

## Versioning (automated — do not hand-bump casually)

`.github/workflows/bump-version.yaml` manages `Chart.yaml` versions:

- Watches `stable/{argocd-instance,argocd-operator,aurora-namespace,aurora-platform,aurora-solution,istio-custom-responses,istio-ingress-gateway}`.
- On changes it bumps **patch** automatically, except `argocd-instance` which bumps **minor** (and resets patch).
- If a `Chart.yaml` version was edited manually in the same change, the auto-bump is **skipped** for that chart.
- On PRs it posts a preview comment; on push to `main` it opens an auto-bump PR.
- The subcharts `aurora-core`/`aurora-app`/`aurora-mgmt` stay pinned at `0.0.1` and are
  **not** in the watched list — they version with the umbrella chart.

Practical rule: change chart contents and let CI bump the version. Only edit `Chart.yaml`
version manually when you specifically need to override the automatic bump.

## Validation & release pipeline

- `render-validate-helm.yaml` (PRs + push to main):
  ```
  helm template aurora stable/aurora-platform \
    --namespace platform-management-system \
    --values config/config.yaml \
    --include-crds > rendered.yaml
  kubeconform -strict -summary \
    -schema-location default \
    -schema-location https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json \
    rendered.yaml
  ```
  `kubeconform` validates the rendered ArgoCD `Application` objects against the argoproj CRD schema.
- `release-helm.yaml` runs after a successful render+validate on `main`, using
  `helm/chart-releaser-action` against `charts_dir: stable` with `skip_existing: true`
  (publishes packaged charts to the `gh-pages`-served Helm repo at
  `https://gccloudone-aurora.github.io/aurora-platform-charts`).

## Local commands (match CI before opening a PR)

Render + validate the umbrella chart exactly as CI does:

```bash
helm template aurora stable/aurora-platform \
  --namespace platform-management-system \
  --values config/config.yaml \
  --include-crds > /tmp/rendered.yaml
```

Lint / render a single standalone chart:

```bash
helm lint stable/<chart>
helm template test stable/<chart> --values stable/<chart>/values.yaml
```

Regenerate docs and the README charts section after chart changes:

```bash
./scripts/run-helm-docs.sh      # per-chart READMEs from README.md.gotmpl (needs helm-docs)
./scripts/generate-readme.sh    # rewrites the auto-managed block in root README.md (needs yq)
```

The root README section between `<!-- START OF CHARTS SECTION -->` and
`<!-- END OF CHARTS SECTION -->` is **auto-generated — do not edit by hand.**

## Common tasks — how to approach them

**Upgrade an upstream component version**
1. Find the component's Application template: `stable/aurora-platform/charts/<subchart>/templates/<component>/<component>.yaml`.
2. Update the `targetRevision` default (the pinned upstream chart version).
3. If the upstream chart's values schema changed, update the inline `helm.values: |` block and the subchart `values.yaml` defaults.
4. Render with `config/config.yaml` and confirm the Application still validates.

**Add a new component**
1. Decide the tier: core (`aurora-core`), app (`aurora-app`), or mgmt (`aurora-mgmt`).
2. Create `templates/<component>/<component>.yaml` following the Application pattern above (enable guard, name, source precedence, destination namespace, syncPolicy).
3. Add `_helpers.tpl` for image construction / workload identity if the upstream chart needs it.
4. Add defaults under `.Values.components.<name>` in that subchart's `values.yaml` (include `enabled:`, `helm: {}`, `image`, resources, etc.).
5. Add supporting `namespace.yaml` / `netpol.yaml` / `rbac.yaml` as needed for the component's namespace.
6. Wire an example into `config/config.yaml` under the right `core|app|mgmt.components` block.
7. Render + kubeconform, then run helm-docs and generate-readme.

**Toggle a component on/off**
Set `<tier>.components.<name>.enabled` in the consuming values (`config.yaml`). The enable
guard in the template controls whether the Application is rendered.

**Debug a component that isn't deploying**
1. Render and grep for the Application: does it appear in the output at all? If not, check the `enabled` guard and that its tier (`core|app|mgmt`) is enabled.
2. Inspect `spec.source` — is `chart`/`repoURL`/`targetRevision` correct and reachable?
3. Inspect the inline `helm.values` indentation — `nindent` mistakes silently produce broken values.
4. On-cluster, the failure is usually in ArgoCD (sync/health of the Application), not in `helm template`.

## Guardrails specific to this repo

The non-negotiable rules (AVP secret refs, `<FILLIN_...>` placeholders,
auto-generated README block, CI-managed `Chart.yaml` versions, YAML-in-YAML
indentation) live in the always-on steering file
`.kiro/steering/aurora-platform-charts.md`. Follow those in addition to the
component conventions above (name prefix, finalizer, project, syncPolicy) so
kubeconform and ArgoCD stay happy.
