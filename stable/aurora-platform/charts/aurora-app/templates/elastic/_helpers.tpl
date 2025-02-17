{{/*
The image section for Elastic Operator.
*/}}
{{- define "elastic.image" -}}
{{- if (and .Values.components.elastic.image.registry .Values.components.elastic.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.elastic.image.registry .Values.components.elastic.image.repository }}
{{- else if .Values.components.elastic.image.repository }}
repository: {{ printf "%s/%s" (default "docker.elastic.co" .Values.global.container.registry) .Values.components.elastic.image.repository }}
{{- end }}
{{- if .Values.components.elastic.image.tag }}
tag: {{ .Values.components.elastic.image.tag }}
{{- end }}
{{- if .Values.components.elastic.image.pullPolicy }}
pullPolicy: {{ .Values.components.elastic.image.pullPolicy }}
{{- end }}
{{- end }}
