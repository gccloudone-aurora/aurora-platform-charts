# Gateway API on Aurora workload clusters

## Ownership and prerequisites

- The platform owns the Istio `GatewayClass` and the `Gateway` in `ingress-general-system`. Solution builders own `HTTPRoute` resources in their bound solution namespaces.
- Enabling `app.components.istio.gatewayAPI.enabled` installs the Gateway API standard custom resource definitions (CRDs) through Argo CD from the upstream [`v1.4.1` release](https://github.com/kubernetes-sigs/gateway-api/tree/v1.4.1/config/crd/standard). The pin matches the current Istio 1.29 line, which added support for Gateway API v1.4.1 in [Istio 1.29.3](https://istio.io/latest/news/releases/1.29.x/announcing-1.29.3/). Update the pin alongside a verified Istio compatibility change.
- This chart owns the CRDs for Istio workload clusters across cloud providers. Leave Terraform's `gateway_api_enabled` false on these clusters so AKS and Argo CD do not manage the same cluster-scoped CRDs.
- For a cluster that already uses AKS-managed CRDs, inventory and back up its Gateway API resources before changing ownership. Disabling AKS Managed Gateway API removes its CRDs; restore the saved resources after the Argo CD-managed CRDs are installed.
- The chart uses the existing self-managed Istio controller. Microsoft documents that AKS support for managed Gateway API CRDs requires a supported AKS add-on or extension; self-managed Gateway API implementations are not supported by AKS. Confirm this support posture for issue [#487](https://github.com/gccloudone-aurora/roadmap/issues/487) before Azure rollout.
- Keep the central NGINX ingress cluster outside this rollout, as required by [#481](https://github.com/gccloudone-aurora/roadmap/issues/481).

## Configure a workload cluster

1. Set `app.components.istio.gatewayAPI.enabled: true` in the cluster's `aurora-platform` values. The Argo CD CRD application syncs first; the Gateway application syncs after it. The `argocd-instance` chart configures Application health so sync waves wait for the CRD application. Set `global.load_balancer_subnet_name` on Azure and confirm `global.ingressDomain` and the `letsencrypt` ClusterIssuer.
2. Leave `legacyGatewayEnabled` and `ingressIstioControllerEnabled` set to `true` during cutover. The ingress namespace allows two load balancers while both gateways run.
3. The platform chart creates the wildcard certificate, the Gateway with HTTP and HTTPS listeners, and an HTTP-to-HTTPS redirect. The HTTPS listener accepts Routes only from namespaces labeled `namespace.ssc-spc.gc.ca/purpose: solution`. The default Gateway name is `general`.
4. In a solution namespace, create an `HTTPRoute` with `parentRefs.name: general`, `parentRefs.namespace: ingress-general-system`, and `parentRefs.sectionName: https`. Keep backend Services in the same namespace unless the backend owner supplies a `ReferenceGrant`.

## Non-production acceptance check

1. Adapt [`examples/gateway-api/echo.yaml`](../examples/gateway-api/echo.yaml) for an approved non-production solution namespace and a hostname under `global.ingressDomain`; deploy it there.
2. Check the Gateway's `Accepted` and `Programmed` conditions, the Certificate's `Ready` condition, and the sample Route's `Accepted` and `ResolvedRefs` conditions. Inspect the generated `general-istio` Service and confirm it has an internal load balancer address.
3. Resolve the sample hostname to that address. Confirm HTTPS reaches the echo Service and HTTP returns a 301 redirect to HTTPS. Record the result for issue #487.
4. Move application Routes and hostnames one at a time. After observing traffic, set `legacyGatewayEnabled: false` and `ingressIstioControllerEnabled: false`.

## References

- [Istio Gateway API deployment and generated-resource customization](https://istio.io/latest/docs/tasks/traffic-management/ingress/gateway-api/)
- [Gateway API role model](https://gateway-api.sigs.k8s.io/docs/concepts/roles-and-personas/)
- [Gateway API cross-namespace references](https://gateway-api.sigs.k8s.io/reference/api-types/referencegrant/)
- [AKS Managed Gateway API support and bundle versions](https://learn.microsoft.com/azure/aks/managed-gateway-api)
