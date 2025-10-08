# argocd-instance

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.15](https://img.shields.io/badge/AppVersion-2.5.15-informational?style=flat-square)

A Helm chart that configures Argo CD.

## Prerequisites

- Kubernetes 1.28+
- Helm v3.19.0+

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocdInstance.applicationInstanceLabelKey | string | `"platform.ssc-spc.gc.ca/application-name"` |  |
| argocdInstance.applicationSet.resources | object | `{}` |  |
| argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.enabled | bool | `false` |  |
| argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.identityName | string | `"argocd-vault-plugin"` |  |
| argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.clientID | string | `""` |  |
| argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.resourceID | string | `""` |  |
| argocdInstance.argocdVaultPlugin.configMapName | string | `"cmp-plugin"` |  |
| argocdInstance.argocdVaultPlugin.env.ARGOCD_ENV_AVP_TYPE | string | `""` |  |
| argocdInstance.argocdVaultPlugin.image.name | string | `"argocd-repo-server"` |  |
| argocdInstance.argocdVaultPlugin.image.version | string | `"main"` |  |
| argocdInstance.argocdVaultPlugin.imageRegistry.host | string | `"ghcr.io"` |  |
| argocdInstance.argocdVaultPlugin.imageRegistry.repository | string | `"gccloudone-aurora"` |  |
| argocdInstance.controller.resources | object | `{}` |  |
| argocdInstance.disableAdmin | bool | `false` |  |
| argocdInstance.image.name | string | `"argoproj/argocd"` |  |
| argocdInstance.image.version | string | `"v2.6.6"` |  |
| argocdInstance.imageRegistry.host | string | `"docker.io"` |  |
| argocdInstance.imageRegistry.repository | string | `""` |  |
| argocdInstance.ingressDomain | string | `""` |  |
| argocdInstance.logLevel | string | `"info"` |  |
| argocdInstance.nodeSelector | object | `{}` |  |
| argocdInstance.notifications.enabled | bool | `false` |  |
| argocdInstance.oidcAuthSP.clientID | string | `""` |  |
| argocdInstance.oidcAuthSP.clientSecret | string | `""` |  |
| argocdInstance.oidcAuthSP.tenantID | string | `""` |  |
| argocdInstance.redis.image.name | string | `"redis"` |  |
| argocdInstance.redis.image.version | string | `"6.2.6"` |  |
| argocdInstance.redis.resources | object | `{}` |  |
| argocdInstance.repo.image.name | string | `"argoproj/argocd"` |  |
| argocdInstance.repo.image.version | string | `"v2.6.6"` |  |
| argocdInstance.repo.resources | object | `{}` |  |
| argocdInstance.server.autoscale.enabled | bool | `false` |  |
| argocdInstance.server.resources | object | `{}` |  |
| argocdInstance.server.service.type | string | `"NodePort"` |  |
| argocdInstance.tolerations | list | `[]` |  |
| netpol.enabled | bool | `false` |  |
| register.clusters | object | `{}` |  |
| register.repositories | object | `{}` |  |
| register.repositoryCreds | object | `{}` |  |
