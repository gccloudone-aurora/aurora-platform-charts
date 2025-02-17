{{/*
The image section for CNP Controller.
*/}}
{{- define "auroraController.image" -}}
{{- if (and .Values.components.auroraController.image.registry .Values.components.auroraController.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.auroraController.image.registry .Values.components.auroraController.image.repository }}
{{- else if .Values.components.auroraController.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.auroraController.image.repository }}
{{- end }}
{{- if .Values.components.auroraController.image.tag }}
tag: {{ .Values.components.auroraController.image.tag }}
{{- end }}
{{- if .Values.components.auroraController.image.pullPolicy }}
pullPolicy: {{ .Values.components.auroraController.image.pullPolicy }}
{{- end }}
{{- end }}
