{{/*
The image section for Bill of Landing
*/}}
{{- define "billOfLanding.image" -}}
{{- if (and .Values.components.billOfLanding.image.registry .Values.components.billOfLanding.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.billOfLanding.image.registry .Values.components.billOfLanding.image.repository }}
{{- else if .Values.components.billOfLanding.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.billOfLanding.image.repository }}
{{- end }}
{{- if .Values.components.billOfLanding.image.tag }}
tag: {{ .Values.components.billOfLanding.image.tag }}
{{- end }}
{{- if .Values.components.billOfLanding.image.pullPolicy }}
pullPolicy: {{ .Values.components.billOfLanding.image.pullPolicy }}
{{- end }}
{{- end }}
