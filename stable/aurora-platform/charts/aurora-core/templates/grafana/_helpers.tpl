{{/*
The image section for Grafana Operator.
*/}}
{{- define "grafana-operator.image" -}}
{{- if .Values.components.grafana.image.registry }}
registry: {{ .Values.components.grafana.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.grafana.image.repository }}
repository: {{ .Values.components.grafana.image.repository }}
{{- end }}
{{- if .Values.components.grafana.image.tag }}
tag: {{ .Values.components.grafana.image.tag }}
{{- end }}
{{- if .Values.components.grafana.image.pullPolicy }}
pullPolicy: {{ .Values.components.grafana.image.pullPolicy }}
{{- end }}
{{- end }}
