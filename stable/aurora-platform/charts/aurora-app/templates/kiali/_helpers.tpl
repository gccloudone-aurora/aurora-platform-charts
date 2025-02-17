{{/*
The image section for Kiali.
*/}}
{{- define "kiali.image" -}}
{{- if (and .Values.components.kiali.image.registry .Values.components.kiali.image.repository) }}
repo: {{ printf "%s/%s" .Values.components.kiali.image.registry .Values.components.kiali.image.repository }}
{{- else if .Values.components.kiali.image.repository }}
repo: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.kiali.image.repository }}
{{- end }}
{{- if .Values.components.kiali.image.tag }}
tag: {{ .Values.components.kiali.image.tag }}
{{- end }}
{{- if .Values.components.kiali.image.pullPolicy }}
pullPolicy: {{ .Values.components.kiali.image.pullPolicy }}
{{- end }}
{{- if .Values.components.kiali.imagePullSecrets }}
pullSecrets: {{ .Values.components.kiali.imagePullSecrets }}
{{- end }}
{{- end }}

{{/*
The image section for a Kiali Instance.
*/}}
{{- define "kiali.instance.image" -}}
{{- printf "%s/%s" (default "docker.io" .values.global.container.registry) "kiali/kiali" }}
{{- end }}
