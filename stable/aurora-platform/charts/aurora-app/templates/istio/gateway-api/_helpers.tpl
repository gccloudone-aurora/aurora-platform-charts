{{/*
gatewayAPI.proxyImage returns the private-registry istio-proxy image for the
Gateway API data plane, or empty if global.container.registry is unset.

When a registry is set, the image is:
  {registry}/istio/proxyv2:{tag}[-{variant}]

Tag order: istiod.proxy.image.tag, then istiod.image.tag, then
istiod.helm.targetRevision (upstream chart version, e.g. 1.29.7).
Variant order: istiod.proxy.image.variant, then istiod.image.variant.

_configmap.yaml writes this onto the generated Deployment's istio-proxy container.
If this helper is empty, Istio keeps the control-plane default image.
*/}}
{{- define "gatewayAPI.proxyImage" -}}
{{- if and .Values.global.container .Values.global.container.registry }}
{{- $proxyTag := default .Values.components.istio.istiod.helm.targetRevision (default .Values.components.istio.istiod.image.tag .Values.components.istio.istiod.proxy.image.tag) -}}
{{- $proxyVariant := default .Values.components.istio.istiod.image.variant .Values.components.istio.istiod.proxy.image.variant -}}
{{- if $proxyVariant }}
{{- $proxyTag = printf "%s-%s" $proxyTag $proxyVariant -}}
{{- end }}
{{- printf "%s/istio/proxyv2:%s" (trimSuffix "/" .Values.global.container.registry) $proxyTag -}}
{{- end }}
{{- end }}
