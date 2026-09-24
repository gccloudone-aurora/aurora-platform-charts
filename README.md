# Aurora Platform Charts

Oversees the deployment of all platform components for the entire Aurora platform.

Please consult the [Project Aurora Template](https://github.com/gccloudone-aurora/project-aurora-template/) which leverages these Platform Charts.

![Aurora Platform](/assets/images/aurora-platform-components.png)

## Using the charts

These are Helm 3 application charts for deploying Aurora platform components to Kubernetes. The
[`stable`](./stable) directory contains the chart sources, and each chart has a generated README
with its available values. For the Azure deployment context, see the [Aurora Azure architecture
introduction](https://aurora.gccloudone.alpha.canada.ca/en/architecture/introduction/azure/).

### 1. Add the chart repository

Released charts are published to GitHub Pages. Add the repository once, then search the available
chart names and versions:

```bash
helm repo add aurora https://gccloudone-aurora.github.io/aurora-platform-charts
helm repo update
helm search repo aurora
```

### 2. Choose a chart

- [`aurora-platform`](./stable/aurora-platform/README.md) is the cluster platform bundle. It
  includes the `aurora-core`, `aurora-app`, and `aurora-mgmt` subcharts; core is enabled by
  default, while application and management components are opt-in.
- [`aurora-namespace`](./stable/aurora-namespace/README.md) creates a namespace with Aurora
  metadata, network policies, security admission labels, RBAC, and resource quotas.
- [`aurora-solution`](./stable/aurora-solution/README.md) creates Argo CD Applications for
  solution namespaces across the configured clusters.
- [`argocd-instance`](./stable/argocd-instance/README.md) and [`argocd-operator`](./stable/argocd-operator/README.md)
  install Argo CD components.
- [`istio-ingress-gateway`](./stable/istio-ingress-gateway/README.md),
  [`istio-custom-responses`](./stable/istio-custom-responses/README.md), and [`raw`](./stable/raw/README.md)
  provide focused supporting charts.

### 3. Create an environment values file

Copy the relevant chart values file and replace its environment-specific placeholders. For the
platform bundle, start with [`stable/aurora-platform/values.yaml`](./stable/aurora-platform/values.yaml):

```yaml
global:
  provider: azure
  cluster: in-cluster
  ingressDomain: example.ca
  namespace:
    helm:
      repository: https://gccloudone-aurora.github.io/aurora-platform-charts
      chart: aurora-namespace
      targetRevision: 0.0.22
  raw:
    helm:
      repository: https://gccloudone-aurora.github.io/aurora-platform-charts
      chart: raw
      targetRevision: 0.0.1

core:
  enabled: true
app:
  enabled: false
mgmt:
  enabled: false
```

Enable platform components under `core.components`, `app.components`, or `mgmt.components` as
needed. Keep chart versions pinned with `targetRevision` when Argo CD Applications reference
published charts.

### 4. Render and validate before deployment

Use Helm to lint and render the chart with the same namespace and values pattern used by CI:

```bash
helm lint stable/aurora-platform --values config/config.yaml
helm template aurora stable/aurora-platform \
  --namespace platform-management-system \
  --values config/config.yaml \
  --include-crds > rendered.yaml
```

Validate the rendered manifest with `kubeconform` before applying it. The repository's CI workflow
uses this render-and-validate step for pull requests and pushes to `main`.

### 5. Deploy with Helm or Argo CD

For a direct Helm release, install a published chart with a release name that matches the chart's
intended namespace conventions:

```bash
helm upgrade --install aurora-namespace aurora/aurora-namespace \
  --namespace aurora-namespace \
  --create-namespace \
  --values namespace-values.yaml
```

For the platform workflow, commit the values file to the environment or template repository and
let Argo CD synchronize the generated `Application` resources. `aurora-platform` passes chart
repositories and target revisions through its `global.namespace.helm`, `global.raw.helm`, and
component-specific values.

## Release and promotion workflow

Chart changes follow a single release unit:

1. Bump the parent chart version.
2. Test the new chart immediately on MGMT (DEV).
3. After the DEV test succeeds, plan and trigger the rollout to all clusters.
4. Argo CD automated sync runs from 07:00 to 09:00 on Tuesdays and Thursdays.

The `aurora-platform` subcharts are intentionally coupled to the parent chart. They are included
and released with the parent rather than bumped independently. This keeps the platform versioning
and rollout process simple and avoids the maintenance overhead of managing disjoint subchart
releases. Treat a subchart change as part of the next parent chart bump.

## Dependency Updates

Renovate is configured in [`renovate.json`](./renovate.json) to update the dependency surfaces that can be safely detected in this repository:

- Helm chart dependencies in `Chart.yaml` and `Chart.lock` files.
- Container image tags in Helm `values.yaml` files and `config/config.yaml`.
- Helm chart versions declared as `targetRevision` in the template-based ArgoCD application values files (ex. Cilium).
- GitHub Actions used by repository workflows.
- Known upstream registries are mapped explicitly for public images so Renovate resolves chart and image updates against the correct source registry.

Renovate intentionally does not manage this repository's own chart `version` fields because chart version bumps are handled by the existing `Bump Helm Chart Versions` workflow. It also skips branch-like image tags such as `main` and `master`.

Renovate runs from the `Renovate` GitHub Actions workflow because the hosted Renovate app is not installed for this organization. The workflow requires a repository secret named `RENOVATE_TOKEN`; use a token that can create branches and pull requests, and include workflow write access so Renovate can update GitHub Actions files. Public registries do not need auth (ex docker usr/PAT). If a chart pulls images from an internal registry, that registry must be configured explicitly.

<!-- START OF CHARTS SECTION -->

> _Auto-generated by `scripts/generate-readme.sh` on 2026-08-13 15:31 UTC_


## argocd-instance
- **Version:** 0.19.0
- **Description:** A Helm chart that configures Argo CD.
- **Documentation:** [README](./stable/argocd-instance/README.md)

## argocd-operator
- **Version:** 0.0.13
- **Description:** A Helm chart that deploys ArgoCD Operator.
- **Documentation:** [README](./stable/argocd-operator/README.md)

## aurora-namespace
- **Version:** 0.0.22
- **Description:** Aurora Namespace
- **Documentation:** [README](./stable/aurora-namespace/README.md)
- **Dependencies:**
  - [raw](./stable/raw/README.md) (local, version: 0.0.1)

## aurora-platform
- **Version:** 0.0.296
- **Description:** Aurora Platform
- **Documentation:** [README](./stable/aurora-platform/README.md)
- **Dependencies:**
  - [aurora-core](./stable/aurora-platform/charts/aurora-core/README.md) (local, version: 0.0.1)
    - _(Template-based ArgoCD Applications):_
      - [alloy](./stable/aurora-platform/charts/aurora-core/templates/alloy)
      - [aurora-controller](./stable/aurora-platform/charts/aurora-core/templates/aurora-controller)
      - [aws-ebs-csi-driver](./stable/aurora-platform/charts/aurora-core/templates/aws-ebs-csi-driver)
      - [aws-loadbalancer-controller](./stable/aurora-platform/charts/aurora-core/templates/aws-loadbalancer-controller)
      - [cert-manager](./stable/aurora-platform/charts/aurora-core/templates/cert-manager)
      - [cidr-allocator](./stable/aurora-platform/charts/aurora-core/templates/cidr-allocator)
      - [cilium](./stable/aurora-platform/charts/aurora-core/templates/cilium)
      - [default](./stable/aurora-platform/charts/aurora-core/templates/default)
      - [falco](./stable/aurora-platform/charts/aurora-core/templates/falco)
      - [fluent-operator](./stable/aurora-platform/charts/aurora-core/templates/fluent-operator)
      - [gatekeeper](./stable/aurora-platform/charts/aurora-core/templates/gatekeeper)
      - [global](./stable/aurora-platform/charts/aurora-core/templates/global)
      - [grafana](./stable/aurora-platform/charts/aurora-core/templates/grafana)
      - [kube-bench](./stable/aurora-platform/charts/aurora-core/templates/kube-bench)
      - [kubecost](./stable/aurora-platform/charts/aurora-core/templates/kubecost)
      - [ntp](./stable/aurora-platform/charts/aurora-core/templates/ntp)
      - [podtracker](./stable/aurora-platform/charts/aurora-core/templates/podtracker)
      - [priority-classes](./stable/aurora-platform/charts/aurora-core/templates/priority-classes)
      - [prometheus](./stable/aurora-platform/charts/aurora-core/templates/prometheus)
      - [rbac](./stable/aurora-platform/charts/aurora-core/templates/rbac)
      - [secrets-store-csi-driver](./stable/aurora-platform/charts/aurora-core/templates/secrets-store-csi-driver)
      - [tetragon](./stable/aurora-platform/charts/aurora-core/templates/tetragon)
      - [trivy-operator](./stable/aurora-platform/charts/aurora-core/templates/trivy-operator)
      - [trust-manager](./stable/aurora-platform/charts/aurora-core/templates/trust-manager)
      - [vault-agent](./stable/aurora-platform/charts/aurora-core/templates/vault-agent)
      - [velero](./stable/aurora-platform/charts/aurora-core/templates/velero)
  - [aurora-app](./stable/aurora-platform/charts/aurora-app/README.md) (local, version: 0.0.1)
    - _(Template-based ArgoCD Applications):_
      - [argo-controller](./stable/aurora-platform/charts/aurora-app/templates/argo-controller)
      - [argo-workflow](./stable/aurora-platform/charts/aurora-app/templates/argo-workflow)
      - [elastic](./stable/aurora-platform/charts/aurora-app/templates/elastic)
      - [istio](./stable/aurora-platform/charts/aurora-app/templates/istio)
      - [kiali](./stable/aurora-platform/charts/aurora-app/templates/kiali)
      - [sidecar-terminator](./stable/aurora-platform/charts/aurora-app/templates/sidecar-terminator)
      - [solr](./stable/aurora-platform/charts/aurora-app/templates/solr)
      - [strimzi](./stable/aurora-platform/charts/aurora-app/templates/strimzi)
  - [aurora-mgmt](./stable/aurora-platform/charts/aurora-mgmt/README.md) (local, version: 0.0.1)
    - _(Template-based ArgoCD Applications):_
      - [argo-foundation](./stable/aurora-platform/charts/aurora-mgmt/templates/argo-foundation)
      - [argo-operator](./stable/aurora-platform/charts/aurora-mgmt/templates/argo-operator)
      - [argo-solutions](./stable/aurora-platform/charts/aurora-mgmt/templates/argo-solutions)
      - [bill-of-landing](./stable/aurora-platform/charts/aurora-mgmt/templates/bill-of-landing)
      - [loki](./stable/aurora-platform/charts/aurora-mgmt/templates/loki)
      - [thanos](./stable/aurora-platform/charts/aurora-mgmt/templates/thanos)

## aurora-app
- **Version:** 0.0.1
- **Description:** Aurora Platform - Application Components
- **Documentation:** [README](./stable/aurora-platform/charts/aurora-app/README.md)

## aurora-core
- **Version:** 0.0.1
- **Description:** Aurora Platform - Core Platform
- **Documentation:** [README](./stable/aurora-platform/charts/aurora-core/README.md)

## aurora-mgmt
- **Version:** 0.0.1
- **Description:** Aurora Platform - Management Components
- **Documentation:** [README](./stable/aurora-platform/charts/aurora-mgmt/README.md)

## aurora-solution
- **Version:** 0.0.32
- **Description:** Aurora Solution
- **Documentation:** [README](./stable/aurora-solution/README.md)

## istio-custom-responses
- **Version:** 0.0.1
- **Description:** A Helm chart that configures custom response templates for Istio.
- **Documentation:** [README](./stable/istio-custom-responses/README.md)

## istio-ingress-gateway
- **Version:** 0.0.9
- **Description:** This chart deploys an opinionated Istio Ingress Gateway.
- **Documentation:** [README](./stable/istio-ingress-gateway/README.md)
- **Dependencies:**
  - gateway (https://istio-release.storage.googleapis.com/charts, version: 1.29.1)

## raw
- **Version:** 0.0.1
- **Description:** A place for all the Kubernetes resources which don't already have a home.
- **Documentation:** [README](./stable/raw/README.md)

<!-- END OF CHARTS SECTION -->

> _End of auto-generated section — do not edit manually._
