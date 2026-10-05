# Gateway API on Aurora workload clusters

## Ownership and prerequisites

- The platform owns the Istio `GatewayClass` and the `Gateway` in `ingress-general-system`. Solution builders own `HTTPRoute` resources in their bound solution namespaces.
- Install the Gateway API custom resource definitions on the workload cluster before enabling `app.components.istio.gatewayAPI.enabled`. The Terraform workload baseline exposes `gateway_api_enabled` for this step.
- The chart uses the existing self-managed Istio controller. Confirm this choice and its [Azure Kubernetes Service support boundary](https://learn.microsoft.com/azure/aks/managed-gateway-api) for issue [#487](https://github.com/gccloudone-aurora/roadmap/issues/487) before rollout.
- Keep the central NGINX ingress cluster outside this rollout, as required by [#481](https://github.com/gccloudone-aurora/roadmap/issues/481).

## Configure a workload cluster

1. Set `app.components.istio.gatewayAPI.enabled: true` in the cluster's `aurora-platform` values. Set `global.load_balancer_subnet_name` on Azure and confirm `global.ingressDomain` and the `letsencrypt` ClusterIssuer.
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
