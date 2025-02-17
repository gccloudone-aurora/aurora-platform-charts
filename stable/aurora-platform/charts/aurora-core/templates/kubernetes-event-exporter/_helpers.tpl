{{/*
The image section for Kubernetes Event Exporter.
*/}}
{{- define "kubernetesEventExporter.image" -}}
{{- if .Values.components.kubernetesEventExporter.image.registry }}
registry: {{ .Values.components.kubernetesEventExporter.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.kubernetesEventExporter.image.repository }}
repository: {{ .Values.components.kubernetesEventExporter.image.repository }}
{{- end }}
{{- if .Values.components.kubernetesEventExporter.image.tag }}
tag: {{ .Values.components.kubernetesEventExporter.image.tag }}
{{- end }}
{{- if .Values.components.kubernetesEventExporter.image.pullPolicy }}
pullPolicy: {{ .Values.components.kubernetesEventExporter.image.pullPolicy }}
{{- end }}
{{- end }}
