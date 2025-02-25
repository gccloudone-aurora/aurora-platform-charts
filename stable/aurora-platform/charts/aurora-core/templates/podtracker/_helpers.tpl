{{/*
The image section for PodTracker.
*/}}
{{- define "podtracker.image" -}}
{{- if (and .Values.components.podtracker.image.registry .Values.components.podtracker.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.podtracker.image.registry .Values.components.podtracker.image.repository }}
{{- else if .Values.components.podtracker.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.podtracker.image.repository }}
{{- end }}
{{- if .Values.components.podtracker.image.tag }}
tag: {{ .Values.components.podtracker.image.tag }}
{{- end }}
{{- if .Values.components.podtracker.image.pullPolicy }}
pullPolicy: {{ .Values.components.podtracker.image.pullPolicy }}
{{- end }}
{{- end }}
