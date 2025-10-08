# Aurora Platform Charts

Oversees the deployment of all platform components for the entire Aurora platform.

Please consult the [Project Aurora Template](https://github.com/gccloudone-aurora/project-aurora-template/) which leverages these Platform Charts.

![Aurora Platform](/assets/images/aurora-platform-components.png)

<!-- START OF CHARTS SECTION -->

## argocd-instance
- **Version:** 0.3.0
- **Description:** A Helm chart that configures Argo CD.
- **Documentation:** [README](./stable/argocd-instance/README.md)

## argocd-operator
- **Version:** 0.0.3
- **Description:** A Helm chart that deploys ArgoCD Operator.
- **Documentation:** [README](./stable/argocd-operator/README.md)

## aurora-namespace
- **Version:** 0.0.1
- **Description:** Aurora Namespace
- **Documentation:** [README](./stable/aurora-namespace/README.md)

## aurora-platform
- **Version:** 0.0.61
- **Description:** Aurora Platform
- **Documentation:** [README](./stable/aurora-platform/README.md)

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
- **Version:** 0.0.1
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

## raw
- **Version:** 0.0.1
- **Description:** A place for all the Kubernetes resources which don't already have a home.
- **Documentation:** [README](./stable/raw/README.md)

<!-- END OF CHARTS SECTION -->
