# Aurora Platform Charts

Oversees the deployment of all platform components for the entire Aurora platform.

Please consult the [Project Aurora Template](https://github.com/gccloudone-aurora/project-aurora-template/) which leverages these Platform Charts.

![Aurora Platform](/assets/images/aurora-platform-components.png)

<!-- START OF CHARTS SECTION -->

## argocd-instance
- **Version:** 0.4.0
- **Description:** A Helm chart that configures Argo CD.
- **Documentation:** [README](./stable/argocd-instance/README.md)

## argocd-operator
- **Version:** 0.0.8
- **Description:** A Helm chart that deploys ArgoCD Operator.
- **Documentation:** [README](./stable/argocd-operator/README.md)

## aurora-namespace
- **Version:** 0.0.1
- **Description:** Aurora Namespace
- **Documentation:** [README](./stable/aurora-namespace/README.md)
- **Dependencies:**
  - [raw](./stable/raw/README.md) (local, version: 0.0.1)

## aurora-platform
- **Version:** 0.0.8
- **Description:** Aurora Platform
- **Documentation:** [README](./stable/aurora-platform/README.md)
- **Dependencies:**
  - [aurora-core](./stable/aurora-platform/charts/aurora-core/README.md) (local, version: 0.0.1)
    - [aad-pod-identity](./stable/aurora-platform/charts/aurora-core/templates/aad-pod-identity)
    - [aurora-controller](./stable/aurora-platform/charts/aurora-core/templates/aurora-controller)
    - [aws-ebs-csi-driver](./stable/aurora-platform/charts/aurora-core/templates/aws-ebs-csi-driver)
    - [aws-loadbalancer-controller](./stable/aurora-platform/charts/aurora-core/templates/aws-loadbalancer-controller)
    - [cert-manager](./stable/aurora-platform/charts/aurora-core/templates/cert-manager)
    - [cidr-allocator](./stable/aurora-platform/charts/aurora-core/templates/cidr-allocator)
    - [cilium](./stable/aurora-platform/charts/aurora-core/templates/cilium)
    - [falco](./stable/aurora-platform/charts/aurora-core/templates/falco)
    - [fluent-operator](./stable/aurora-platform/charts/aurora-core/templates/fluent-operator)
    - [gatekeeper](./stable/aurora-platform/charts/aurora-core/templates/gatekeeper)
    - [global](./stable/aurora-platform/charts/aurora-core/templates/global)
    - [kubecost](./stable/aurora-platform/charts/aurora-core/templates/kubecost)
    - [kubernetes-event-exporter](./stable/aurora-platform/charts/aurora-core/templates/kubernetes-event-exporter)
    - [ntp](./stable/aurora-platform/charts/aurora-core/templates/ntp)
    - [podtracker](./stable/aurora-platform/charts/aurora-core/templates/podtracker)
    - [priority-classes](./stable/aurora-platform/charts/aurora-core/templates/priority-classes)
    - [prometheus](./stable/aurora-platform/charts/aurora-core/templates/prometheus)
    - [rbac](./stable/aurora-platform/charts/aurora-core/templates/rbac)
    - [tetragon](./stable/aurora-platform/charts/aurora-core/templates/tetragon)
    - [trust-manager](./stable/aurora-platform/charts/aurora-core/templates/trust-manager)
    - [vault-agent](./stable/aurora-platform/charts/aurora-core/templates/vault-agent)
    - [velero](./stable/aurora-platform/charts/aurora-core/templates/velero)
  - [aurora-app](./stable/aurora-platform/charts/aurora-app/README.md) (local, version: 0.0.1)
    - [argo-controller](./stable/aurora-platform/charts/aurora-app/templates/argo-controller)
    - [argo-workflow](./stable/aurora-platform/charts/aurora-app/templates/argo-workflow)
    - [elastic](./stable/aurora-platform/charts/aurora-app/templates/elastic)
    - [istio](./stable/aurora-platform/charts/aurora-app/templates/istio)
    - [kiali](./stable/aurora-platform/charts/aurora-app/templates/kiali)
    - [sidecar-terminator](./stable/aurora-platform/charts/aurora-app/templates/sidecar-terminator)
    - [solr](./stable/aurora-platform/charts/aurora-app/templates/solr)
  - [aurora-mgmt](./stable/aurora-platform/charts/aurora-mgmt/README.md) (local, version: 0.0.1)
    - [argo-foundation](./stable/aurora-platform/charts/aurora-mgmt/templates/argo-foundation)
    - [argo-operator](./stable/aurora-platform/charts/aurora-mgmt/templates/argo-operator)
    - [bill-of-landing](./stable/aurora-platform/charts/aurora-mgmt/templates/bill-of-landing)

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
- **Version:** 0.0.2
- **Description:** Aurora Solution
- **Documentation:** [README](./stable/aurora-solution/README.md)

## istio-custom-responses
- **Version:** 0.0.1
- **Description:** A Helm chart that configures custom response templates for Istio.
- **Documentation:** [README](./stable/istio-custom-responses/README.md)

## istio-ingress-gateway
- **Version:** 0.0.3
- **Description:** This chart deploys an opinionated Istio Ingress Gateway.
- **Documentation:** [README](./stable/istio-ingress-gateway/README.md)
- **Dependencies:**
  - gateway (https://istio-release.storage.googleapis.com/charts, version: 1.14.3)

## raw
- **Version:** 0.0.1
- **Description:** A place for all the Kubernetes resources which don't already have a home.
- **Documentation:** [README](./stable/raw/README.md)

<!-- END OF CHARTS SECTION -->
