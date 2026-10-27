{{/*
Tagged proxyv2 image for the Gateway API data plane when a private registry is set.
Merged onto the generated Deployment via the ConfigMap overlay.
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
