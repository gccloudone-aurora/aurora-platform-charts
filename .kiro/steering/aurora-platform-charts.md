---
inclusion: always
---

# Aurora Platform Charts — essentials

Always-on rules and mental model for this repo. Deeper how-to lives in the
`aurora-platform-charts` skill, which loads when you work on charts directly.

## Mental model: Helm renders ArgoCD, ArgoCD runs Helm

The charts here almost never deploy Kubernetes workloads directly. They render
**ArgoCD `Application` resources**; ArgoCD then reconciles those Applications by
pulling and installing the *real* upstream Helm charts onto the target cluster.

```
config values → stable/aurora-platform (umbrella: core/app/mgmt subcharts)
             → templates/<component>/*.yaml → kind: Application (argoproj.io/v1alpha1)
             → ArgoCD syncs → upstream Helm chart installed on cluster
```

Consequences to keep in mind at all times:

- `helm template stable/aurora-platform` outputs **ArgoCD Applications, not
  final workloads**. Do not expect Deployments/DaemonSets in rendered output.
- An Application's `spec.source.helm.values: |` block is the **upstream chart's**
  values (YAML-in-YAML). Indentation errors there fail silently — preserve it exactly.
- Subchart aliases: `core` = aurora-core, `app` = aurora-app, `mgmt` = aurora-mgmt.
  A config value at `core.components.X` maps to `.Values.components.X` inside aurora-core.

## Guardrails (do not violate)

- **Secrets**: `<path:VAULT#key>` values are ArgoCD Vault Plugin (AVP) refs resolved
  at sync time. Never replace them with literal secrets and never echo resolved secrets.
- **Placeholders**: leave `<FILLIN_...>` as placeholders in shared config unless the
  change explicitly targets one environment.
- **Auto-generated content**: never hand-edit the README block between
  `<!-- START OF CHARTS SECTION -->` and `<!-- END OF CHARTS SECTION -->`
  (regenerate with `scripts/generate-readme.sh`).
- **Versions**: `Chart.yaml` versions are bumped by CI (patch; minor for argocd-instance;
  skipped if edited manually). Don't hand-bump unless deliberately overriding CI.
- **Validate before PR**: render the umbrella chart and validate with kubeconform, exactly
  as CI does (see the skill for the exact commands), before pushing chart changes.
