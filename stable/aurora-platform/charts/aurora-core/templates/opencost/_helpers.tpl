{{/*  OpenCost Exporter Image Fields */}}
{{- define "opencost.exporter.image" -}}
registry: {{ .Values.components.opencost.exporter.image.registry | default .Values.global.container.registry | default "ghcr.io" | quote }}
repository: {{ .Values.components.opencost.exporter.image.repository | default "opencost/opencost" | quote }}
{{- if .Values.components.opencost.exporter.image.tag }}
tag: {{ .Values.components.opencost.exporter.image.tag | toString | quote }}
{{- end }}
pullPolicy: {{ .Values.components.opencost.exporter.image.pullPolicy | default "IfNotPresent" | quote }}
{{- end -}}

{{/*  OpenCost UI Image Fields */}}
{{- define "opencost.ui.image" -}}
registry: {{ .Values.components.opencost.ui.image.registry | default .Values.global.container.registry | default "ghcr.io" | quote }}
repository: {{ .Values.components.opencost.ui.image.repository | default "opencost/opencost-ui" | quote }}
{{- if .Values.components.opencost.ui.image.tag }}
tag: {{ .Values.components.opencost.ui.image.tag | toString | quote }}
{{- end }}
pullPolicy: {{ .Values.components.opencost.ui.image.pullPolicy | default "IfNotPresent" | quote }}
{{- end -}}
