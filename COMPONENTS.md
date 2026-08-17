# Aurora Platform Components

This document lists all components deployed in the Aurora Platform with their versions, documentation references, and security/compliance information. All components are sourced from the Cloud Native Computing Foundation (CNCF) ecosystem to ensure compliance with supply chain integrity requirements (SA-12).

**Note:** Cost is $0.00 for all components (open source). Highest data classification: Secret. All components are hosted on GC networks.

---


## Application Components

### Argo Workflows
- **Version:** v4.1.1
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Argo Workflows](https://landscape.cncf.io/?item=app-definition-and-development--continuous-integration-delivery--argo)
- **Documentation:** [Argo Workflows](https://argoproj.github.io/workflows/)
- **Repository:** [argo-workflows](https://github.com/argoproj/argo-workflows)
- **Purpose:** Kubernetes-native workflow automation
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Argocd
- **Version:** v3.1.9
- **CNCF Status:** Graduated
- **CNCF Landscape:** [Argocd](https://landscape.cncf.io/?item=app-definition-and-development--continuous-integration-delivery--argo)
- **Documentation:** [Argocd](https://argo-cd.readthedocs.io/)
- **Repository:** [argo-cd](https://github.com/argoproj/argo-cd)
- **Purpose:** Continuous deployment and GitOps
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Grafana Operator
- **Version:** v5.24.0
- **CNCF Status:** Sandbox
- **CNCF Landscape:** [Grafana Operator](https://landscape.cncf.io/?item=observability-and-analysis--observability--grafana)
- **Documentation:** [Grafana Operator](https://grafana.github.io/grafana-operator/docs/)
- **Repository:** [grafana-operator](https://github.com/grafana/grafana-operator)
- **Purpose:** Kubernetes-native Grafana operator
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Istio
- **Version:** 1.29.1
- **CNCF Status:** Graduated
- **Documentation:** [Istio](https://istio.io/latest/docs/)
- **Repository:** [istio](https://github.com/istio/istio)
- **Purpose:** Service mesh and traffic management
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Kiali
- **Version:** v2.30.0
- **CNCF Status:** Sandbox
- **CNCF Landscape:** [Kiali](https://landscape.cncf.io/?item=observability-and-analysis--observability--kiali)
- **Documentation:** [Kiali](https://github.com/kiali/kiali)
- **Repository:** [kiali](https://github.com/kiali/kiali)
- **Purpose:** Service mesh observability and visualization
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Strimzi Kafka Operator
- **Version:** 1.0.0
- **CNCF Status:** Sandbox
- **CNCF Landscape:** [Strimzi Kafka Operator](https://landscape.cncf.io/?item=app-definition-and-development--streaming-messaging--strimzi)
- **Documentation:** [Strimzi Kafka Operator](https://github.com/strimzi/strimzi-kafka-operator)
- **Repository:** [strimzi-kafka-operator](https://github.com/strimzi/strimzi-kafka-operator)
- **Purpose:** Kubernetes Kafka operator and cluster management
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes


## Core Components

### Alloy
- **Version:** 1.11.0
- **CNCF Status:** Incubating
- **Documentation:** [Alloy](https://grafana.com/docs/alloy/latest/)
- **Repository:** [alloy](https://github.com/grafana/alloy)
- **Purpose:** Observability data collection and pipeline
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Cert Manager
- **Version:** v1.20.3
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Cert Manager](https://landscape.cncf.io/?item=provisioning--security-compliance--cert-manager)
- **Documentation:** [Cert Manager](https://cert-manager.io/docs/)
- **Repository:** [cert-manager](https://github.com/cert-manager/cert-manager)
- **Purpose:** Automated TLS certificate management
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Cilium
- **Version:** 1.19.2
- **CNCF Status:** Graduated
- **CNCF Landscape:** [Cilium](https://landscape.cncf.io/?item=runtime--cloud-native-network--cilium)
- **Documentation:** [Cilium](https://docs.cilium.io/)
- **Repository:** [cilium](https://github.com/cilium/cilium)
- **Purpose:** Cloud-native networking and security
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Fluent Operator
- **Version:** 2.5.0
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Fluent Operator](https://landscape.cncf.io/?item=observability-and-analysis--observability--fluentd)
- **Documentation:** [Fluent Operator](https://github.com/fluent/fluent-operator)
- **Repository:** [fluent-operator](https://github.com/fluent/fluent-operator)
- **Purpose:** Log collection and processing
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Gatekeeper
- **Version:** 3.22.0
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Gatekeeper](https://landscape.cncf.io/?item=cnai--governance-policy-security--opa-gatekeeper)
- **Documentation:** [Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)
- **Repository:** [gatekeeper](https://github.com/open-policy-agent/gatekeeper)
- **Purpose:** Policy enforcement and governance
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Kube Bench
- **Version:** v0.15.5
- **CNCF Status:** Sandbox
- **CNCF Landscape:** [Kube Bench](https://landscape.cncf.io/?item=provisioning--security-compliance--kube-bench)
- **Documentation:** [Kube Bench](https://github.com/aquasecurity/kube-bench)
- **Repository:** [kube-bench](https://github.com/aquasecurity/kube-bench)
- **Purpose:** Kubernetes security benchmark auditing
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Prometheus Operator
- **Version:** v0.62.0
- **CNCF Status:** Graduated
- **CNCF Landscape:** [Prometheus Operator](https://landscape.cncf.io/?item=observability-and-analysis--observability--prometheus)
- **Documentation:** [Prometheus Operator](https://prometheus-operator.dev/)
- **Repository:** [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)
- **Purpose:** Metrics collection and monitoring
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Tetragon
- **Version:** 1.6.0
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Tetragon](https://landscape.cncf.io/?item=provisioning--security-compliance--tetragon)
- **Documentation:** [Tetragon](https://docs.cilium.io/en/stable/observability/tetragon/)
- **Repository:** [tetragon](https://github.com/cilium/tetragon)
- **Purpose:** Runtime security observability
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Trivy Operator
- **Version:** 0.29.0
- **CNCF Status:** Sandbox
- **CNCF Landscape:** [Trivy Operator](https://landscape.cncf.io/?item=provisioning--security-compliance--trivy)
- **Documentation:** [Trivy Operator](https://aquasecurity.github.io/trivy-operator/)
- **Repository:** [trivy-operator](https://github.com/aquasecurity/trivy-operator)
- **Purpose:** Container and Kubernetes vulnerability scanning
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Trust Manager
- **Version:** v0.23.0
- **CNCF Status:** Incubating
- **Documentation:** [Trust Manager](https://cert-manager.io/docs/projects/trust-manager/)
- **Repository:** [trust-manager](https://github.com/cert-manager/trust-manager)
- **Purpose:** Certificate and trust infrastructure management
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Velero
- **Version:** 12.1.0
- **CNCF Status:** Graduated
- **CNCF Landscape:** [Velero](https://landscape.cncf.io/?item=runtime--cloud-native-storage--velero)
- **Documentation:** [Velero](https://velero.io/docs/)
- **Repository:** [velero](https://github.com/velero-io/velero)
- **Purpose:** Kubernetes backup and disaster recovery
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes


## Management Components

### Loki
- **Version:** 6.55.0
- **CNCF Status:** Graduated
- **CNCF Landscape:** [Loki](https://landscape.cncf.io/?item=observability-and-analysis--observability--grafana-loki)
- **Documentation:** [Loki](https://grafana.com/docs/loki/)
- **Repository:** [loki](https://github.com/grafana/loki)
- **Purpose:** Log aggregation and querying
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

### Opencost
- **Version:** UNKNOWN
- **CNCF Status:** Incubating
- **CNCF Landscape:** [Opencost](https://landscape.cncf.io/?item=observability-and-analysis--continuous-optimization--opencost)
- **Documentation:** [Opencost](https://www.opencost.io/docs/)
- **Repository:** [opencost](https://github.com/opencost/opencost)
- **Purpose:** Kubernetes cost visibility and optimization
- **Cost:** $0.00 (open source)
- **Data Classification:** Secret
- **Hosted on GC Networks:** Yes

---

## Compliance Notes

**SA-12 Supply Chain Integrity:**
All components listed above are sourced from the Cloud Native Computing Foundation (CNCF) ecosystem:
- **Graduated Projects:** Industry-standard, widely adopted, rigorous governance
- **Incubating Projects:** Actively developed, under CNCF oversight, community-driven
- **Sandbox Projects:** Early-stage, CNCF-managed, transparent development practices

Each project undergoes:
- Independent third-party vulnerability audits
- Transparent governance and release processes
- Active security maintenance and patching
- Public vulnerability disclosure policies

**Falco Removal:**
Falco (runtime security monitoring) has been removed from the platform in favor of **Tetragon**, which provides superior runtime security observability with tighter Cilium integration and lower performance overhead.

---

## Export Metadata

| Component | Version | Category | CNCF Status | Repository | Cost |
|-----------|---------|----------|-------------|------------|------|
| Argo Workflows | v4.1.1 | Application | Incubating | [argo-workflows](https://github.com/argoproj/argo-workflows) | $0.00 |
| Argocd | v3.1.9 | Application | Graduated | [argo-cd](https://github.com/argoproj/argo-cd) | $0.00 |
| Grafana Operator | v5.24.0 | Application | Sandbox | [grafana-operator](https://github.com/grafana/grafana-operator) | $0.00 |
| Istio | 1.29.1 | Application | Graduated | [istio](https://github.com/istio/istio) | $0.00 |
| Kiali | v2.30.0 | Application | Sandbox | [kiali](https://github.com/kiali/kiali) | $0.00 |
| Strimzi Kafka Operator | 1.0.0 | Application | Sandbox | [strimzi-kafka-operator](https://github.com/strimzi/strimzi-kafka-operator) | $0.00 |
| Alloy | 1.11.0 | Core | Incubating | [alloy](https://github.com/grafana/alloy) | $0.00 |
| Cert Manager | v1.20.3 | Core | Incubating | [cert-manager](https://github.com/cert-manager/cert-manager) | $0.00 |
| Cilium | 1.19.2 | Core | Graduated | [cilium](https://github.com/cilium/cilium) | $0.00 |
| Fluent Operator | 2.5.0 | Core | Incubating | [fluent-operator](https://github.com/fluent/fluent-operator) | $0.00 |
| Gatekeeper | 3.22.0 | Core | Incubating | [gatekeeper](https://github.com/open-policy-agent/gatekeeper) | $0.00 |
| Kube Bench | v0.15.5 | Core | Sandbox | [kube-bench](https://github.com/aquasecurity/kube-bench) | $0.00 |
| Prometheus Operator | v0.62.0 | Core | Graduated | [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator) | $0.00 |
| Tetragon | 1.6.0 | Core | Incubating | [tetragon](https://github.com/cilium/tetragon) | $0.00 |
| Trivy Operator | 0.29.0 | Core | Sandbox | [trivy-operator](https://github.com/aquasecurity/trivy-operator) | $0.00 |
| Trust Manager | v0.23.0 | Core | Incubating | [trust-manager](https://github.com/cert-manager/trust-manager) | $0.00 |
| Velero | 12.1.0 | Core | Graduated | [velero](https://github.com/velero-io/velero) | $0.00 |
| Loki | 6.55.0 | Management | Graduated | [loki](https://github.com/grafana/loki) | $0.00 |
| Opencost | UNKNOWN | Management | Incubating | [opencost](https://github.com/opencost/opencost) | $0.00 |
