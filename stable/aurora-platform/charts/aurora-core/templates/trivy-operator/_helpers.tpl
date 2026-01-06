{{/*
The image section for the trivy-operator image.
*/}}
{{- define "trivy.image" -}}
{{- if (and .Values.components.trivy.image.registry .Values.components.trivy.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.trivy.image.registry .Values.components.trivy.image.repository }}
{{- else if .Values.components.trivy.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.trivy.image.repository }}
{{- end }}
{{- if .Values.components.trivy.image.tag }}
tag: {{ .Values.components.trivy.image.tag }}
{{- end }}
{{- if .Values.components.trivy.image.pullPolicy }}
pullPolicy: {{ .Values.components.trivy.image.pullPolicy }}
{{- end }}
{{- end }}
