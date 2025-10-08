# istio-ingress-gateway

![Version: 0.0.3](https://img.shields.io/badge/Version-0.0.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

This chart deploys an opinionated Istio Ingress Gateway.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://istio-release.storage.googleapis.com/charts | gateway | 1.14.3 |

## Prerequisites

- Kubernetes 1.28+
- Helm v3.19.0+

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gateway.autoscaling.enabled | bool | `true` |  |
| gateway.autoscaling.maxReplicas | int | `5` |  |
| gateway.autoscaling.minReplicas | int | `3` |  |
| gateway.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| gateway.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal" | string | `"true"` |  |
| gateway.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal-subnet" | string | `""` |  |
| gateway.service.loadBalancerIP | string | `""` |  |
| gateway.service.ports[0].name | string | `"status-port"` |  |
| gateway.service.ports[0].nodePort | int | `31813` |  |
| gateway.service.ports[0].port | int | `15021` |  |
| gateway.service.ports[0].protocol | string | `"TCP"` |  |
| gateway.service.ports[0].targetPort | int | `15021` |  |
| gateway.service.ports[1].name | string | `"http"` |  |
| gateway.service.ports[1].nodePort | int | `30540` |  |
| gateway.service.ports[1].port | int | `80` |  |
| gateway.service.ports[1].protocol | string | `"TCP"` |  |
| gateway.service.ports[1].targetPort | int | `80` |  |
| gateway.service.ports[2].name | string | `"https"` |  |
| gateway.service.ports[2].nodePort | int | `31607` |  |
| gateway.service.ports[2].port | int | `443` |  |
| gateway.service.ports[2].protocol | string | `"TCP"` |  |
| gateway.service.ports[2].targetPort | int | `443` |  |
| gateway.service.type | string | `"LoadBalancer"` |  |
| https.certificate.dnsNames | list | `[]` |  |
| https.certificate.issuerRef.kind | string | `nil` |  |
| https.certificate.issuerRef.name | string | `nil` |  |
| https.certificate.secretName | string | `nil` |  |
| https.certificate.useGeneralDNSSolver | bool | `true` |  |
| https.cipherSuites[0] | string | `"ECDHE-RSA-AES256-GCM-SHA384"` |  |
| https.cipherSuites[1] | string | `"ECDHE-RSA-AES128-GCM-SHA256"` |  |
| https.enabled | bool | `true` |  |
| https.hosts | list | `[]` |  |
| https.hsts.enabled | bool | `true` |  |
| https.hsts.value | string | `"max-age=31536000"` |  |
| https.httpsRedirect | bool | `true` |  |
| https.rbac.enabled | bool | `true` |  |
| https.rbac.labels | object | `{}` |  |
| telemetry.accessLogging.enabled | bool | `true` |  |
