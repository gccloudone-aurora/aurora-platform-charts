{{/*
The image section for Strimzi Kafka Operator.
*/}}
{{- define "strimzi.image" -}}
{{- if .Values.components.strimzi.image.registry }}
registry: {{ default .Values.components.strimzi.image.registry .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.strimzi.image.repository }}
repository: {{ .Values.components.strimzi.image.repository }}
{{- end }}
{{- if .Values.components.strimzi.image.name }}
name: {{ .Values.components.strimzi.image.name }}
{{- end }}
{{- if .Values.components.strimzi.image.tag }}
tag: {{ .Values.components.strimzi.image.tag }}(default "quay.io" .Values.global.container.registry)
{{- end }}
{{- if .Values.components.strimzi.image.pullPolicy }}
pullPolicy: {{ .Values.components.strimzi.image.pullPolicy }}
{{- end }}
{{- end }}
