# aurora-mgmt

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.0.0](https://img.shields.io/badge/AppVersion-2.0.0-informational?style=flat-square)

Aurora Platform - Management Components

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| components.argoFoundation.argocdInstance.applicationSet.resources | object | `{}` |  |
| components.argoFoundation.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.enabled | bool | `false` |  |
| components.argoFoundation.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.identityName | string | `"argocd-vault-plugin"` |  |
| components.argoFoundation.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.clientID | string | `""` |  |
| components.argoFoundation.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.resourceID | string | `""` |  |
| components.argoFoundation.argocdInstance.argocdVaultPlugin.env | object | `{}` |  |
| components.argoFoundation.argocdInstance.controller.resources | object | `{}` |  |
| components.argoFoundation.argocdInstance.helm | object | `{}` |  |
| components.argoFoundation.argocdInstance.netpol | object | `{}` |  |
| components.argoFoundation.argocdInstance.nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| components.argoFoundation.argocdInstance.nodeSelector."node.ssc-spc.gc.ca/purpose" | string | `"system"` |  |
| components.argoFoundation.argocdInstance.notifications | object | `{}` |  |
| components.argoFoundation.argocdInstance.oidcAuthSP.credentials | object | `{}` |  |
| components.argoFoundation.argocdInstance.redis.resources | object | `{}` |  |
| components.argoFoundation.argocdInstance.register.clusters | object | `{}` |  |
| components.argoFoundation.argocdInstance.register.repositories | object | `{}` |  |
| components.argoFoundation.argocdInstance.register.repositoryCreds | object | `{}` |  |
| components.argoFoundation.argocdInstance.repo.resources | object | `{}` |  |
| components.argoFoundation.argocdInstance.server.service | object | `{}` |  |
| components.argoFoundation.argocdInstance.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| components.argoFoundation.argocdInstance.tolerations[0].operator | string | `"Exists"` |  |
| components.argoFoundation.argocdProjects.platform | string | `nil` |  |
| components.argoFoundation.argocdProjects.solutions | string | `nil` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].clusters[0] | string | `"*"` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].duration | string | `"5h"` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].kind | string | `"allow"` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].manualSync | bool | `true` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].schedule | string | `"* 19 * * 2,4"` |  |
| components.argoFoundation.argocdProjects.syncWindows[0].timeZone | string | `"America/Toronto"` |  |
| components.argoOperator.affinity | object | `{}` |  |
| components.argoOperator.helm | object | `{}` |  |
| components.argoOperator.image.repository | string | `"argoprojlabs/argocd-operator"` |  |
| components.argoOperator.image.tag | string | `"v0.15.0"` |  |
| components.argoOperator.imagePullSecrets | list | `[]` |  |
| components.argoOperator.nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| components.argoOperator.nodeSelector."node.ssc-spc.gc.ca/purpose" | string | `"system"` |  |
| components.argoOperator.priorityClassName | string | `"platform-cluster-medium"` |  |
| components.argoOperator.replicas | int | `1` |  |
| components.argoOperator.resources | object | `{}` |  |
| components.argoOperator.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| components.argoOperator.tolerations[0].operator | string | `"Exists"` |  |
| components.argoSolution.argocdInstance.applicationSet.resources | object | `{}` |  |
| components.argoSolution.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.enabled | bool | `false` |  |
| components.argoSolution.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.identityName | string | `"argocd-vault-plugin"` |  |
| components.argoSolution.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.clientID | string | `""` |  |
| components.argoSolution.argocdInstance.argocdVaultPlugin.azure.AADPodIdentity.managedIdentity.resourceID | string | `""` |  |
| components.argoSolution.argocdInstance.argocdVaultPlugin.env | object | `{}` |  |
| components.argoSolution.argocdInstance.controller.resources | object | `{}` |  |
| components.argoSolution.argocdInstance.helm | object | `{}` |  |
| components.argoSolution.argocdInstance.netpol | object | `{}` |  |
| components.argoSolution.argocdInstance.nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| components.argoSolution.argocdInstance.nodeSelector."node.ssc-spc.gc.ca/purpose" | string | `"system"` |  |
| components.argoSolution.argocdInstance.notifications | object | `{}` |  |
| components.argoSolution.argocdInstance.oidcAuthSP.credentials | object | `{}` |  |
| components.argoSolution.argocdInstance.redis.resources | object | `{}` |  |
| components.argoSolution.argocdInstance.register.clusters | object | `{}` |  |
| components.argoSolution.argocdInstance.register.repositories | object | `{}` |  |
| components.argoSolution.argocdInstance.register.repositoryCreds | object | `{}` |  |
| components.argoSolution.argocdInstance.repo.resources | object | `{}` |  |
| components.argoSolution.argocdInstance.server.service | object | `{}` |  |
| components.argoSolution.argocdInstance.sourceNamespaces[0] | string | `"/^((?!-system$).)*$/"` |  |
| components.argoSolution.argocdInstance.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| components.argoSolution.argocdInstance.tolerations[0].operator | string | `"Exists"` |  |
| components.argoSolution.enabled | bool | `true` |  |
| components.billOfLanding.AADPodIdentity.azureManagedIdentity | object | `{}` |  |
| components.billOfLanding.config.artifactRepository | object | `{}` |  |
| components.billOfLanding.config.clusters | list | `[]` |  |
| components.billOfLanding.enabled | bool | `false` |  |
| components.billOfLanding.helm | object | `{}` |  |
| components.billOfLanding.image.repository | string | `"bol"` |  |
| components.billOfLanding.nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| components.billOfLanding.nodeSelector."node.ssc-spc.gc.ca/purpose" | string | `"system"` |  |
| components.billOfLanding.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| components.billOfLanding.tolerations[0].operator | string | `"Exists"` |  |
| data.mgmt.enabled | bool | `true` |  |
| global.cluster | string | `"in-cluster"` |  |
| global.container | object | `{}` |  |
| global.helm | object | `{}` |  |
| global.ingressDomain | string | `"example.ca"` |  |
| global.namespace.helm.chart | string | `nil` |  |
| global.namespace.helm.repository | string | `nil` |  |
| global.namespace.helm.targetRevision | string | `nil` |  |
| global.project | string | `"aurora-app"` |  |
| global.raw.helm.chart | string | `nil` |  |
| global.raw.helm.repository | string | `nil` |  |
| global.raw.helm.targetRevision | string | `nil` |  |
| rbac.platformAdmin.groups | list | `[]` |  |
| rbac.platformAdmin.users | list | `[]` |  |
| rbac.platformOperator.groups | list | `[]` |  |
| rbac.platformOperator.users | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
