{{/*
The image section for the trivy-operator image.
*/}}
{{- define "trivy.image" -}}
{{- if .Values.components.trivy.image.registry }}
registry: {{ .Values.components.trivy.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- else }}
registry: {{ default "docker.io" .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.trivy.image.repository }}
repository: {{ .Values.components.trivy.image.repository }}
{{- end }}
{{- if .Values.components.trivy.image.tag }}
tag: {{ .Values.components.trivy.image.tag }}
{{- end }}
{{- if .Values.components.trivy.image.pullPolicy }}
pullPolicy: {{ .Values.components.trivy.image.pullPolicy }}
{{- end }}
{{- end }}
