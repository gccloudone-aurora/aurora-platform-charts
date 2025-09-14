{{/*
The image section for Tetragon.
*/}}
{{- define "tetragon.image" -}}
{{- if (and .Values.components.tetragon.image.registry .Values.components.tetragon.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.tetragon.image.registry .Values.components.tetragon.image.repository }}
{{- else if .Values.components.tetragon.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.tetragon.image.repository }}
{{- end }}
{{- if .Values.components.tetragon.image.tag }}
tag: {{ .Values.components.tetragon.image.tag }}
{{- end }}
{{- if .Values.components.tetragon.image.pullPolicy }}
pullPolicy: {{ .Values.components.tetragon.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Tetragon Operator.
*/}}
{{- define "tetragon.operator.image" -}}
{{- if (and .Values.components.tetragon.operator.image.registry .Values.components.tetragon.operator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.tetragon.operator.image.registry .Values.components.tetragon.operator.image.repository }}
{{- else if .Values.components.tetragon.operator.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.tetragon.operator.image.repository }}
{{- end }}
{{- if .Values.components.tetragon.operator.image.tag }}
tag: {{ .Values.components.tetragon.image.tag }}
{{- end }}
{{- if .Values.components.tetragon.operator.image.pullPolicy }}
pullPolicy: {{ .Values.components.tetragon.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Tetragon Export.
*/}}
{{- define "tetragon.export.image" -}}
{{- if (and .Values.components.tetragon.export.image.registry .Values.components.tetragon.export.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.tetragon.export.image.registry .Values.components.tetragon.export.image.repository }}
{{- else if .Values.components.tetragon.export.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.tetragon.export.image.repository }}
{{- end }}
{{- if .Values.components.tetragon.export.image.tag }}
tag: {{ .Values.components.tetragon.image.tag }}
{{- end }}
{{- if .Values.components.tetragon.export.image.pullPolicy }}
pullPolicy: {{ .Values.components.tetragon.image.pullPolicy }}
{{- end }}
{{- end }}
