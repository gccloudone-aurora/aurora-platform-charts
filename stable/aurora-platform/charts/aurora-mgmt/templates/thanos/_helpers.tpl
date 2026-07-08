{{/*
Thanos container image as a flat "registry/repository:tag" string for deployment.
*/}}
{{- define "thanos.image" -}}
{{- $img := .Values.components.thanos.image -}}
{{- $registry := coalesce $img.registry .Values.global.container.registry "quay.io" -}}
{{- $repository := required "components.thanos.image.repository is required" $img.repository -}}
{{- $tag := required "components.thanos.image.tag is required (pin the Thanos version)" $img.tag -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}
