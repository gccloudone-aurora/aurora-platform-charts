{{/*
The image section for Sidecar Terminator.
*/}}
{{- define "sidecar-terminator.image" -}}
{{- if (and .Values.components.sidecarTerminator.image.registry .Values.components.sidecarTerminator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.sidecarTerminator.image.registry .Values.components.sidecarTerminator.image.repository }}
{{- else if .Values.components.sidecarTerminator.image.repository }}
repository: {{ printf "%s/%s" (default "ghcr.io" .Values.global.container.registry) .Values.components.sidecarTerminator.image.repository }}
{{- end }}
{{- if .Values.components.sidecarTerminator.image.tag }}
tag: {{ .Values.components.sidecarTerminator.image.tag }}
{{- end }}
{{- if .Values.components.sidecarTerminator.image.pullPolicy }}
pullPolicy: {{ .Values.components.sidecarTerminator.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Sidecar Terminator Ephemeral.
*/}}
{{- define "sidecar-terminator-ephemeral.image" -}}
{{- if (and .Values.components.sidecarTerminator.terminator.image.registry .Values.components.sidecarTerminator.terminator.image.repository) }}
image: {{ printf "%s/%s" .Values.components.sidecarTerminator.terminator.image.registry .Values.components.sidecarTerminator.terminator.image.repository }}
{{- else if .Values.components.sidecarTerminator.terminator.image.repository }}
image: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.sidecarTerminator.terminator.image.repository }}
{{- end }}
{{- end }}
