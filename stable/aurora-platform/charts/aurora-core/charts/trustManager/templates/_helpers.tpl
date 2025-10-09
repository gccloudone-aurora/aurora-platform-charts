{{/*
The image section for Trust Manager.
*/}}
{{- define "image" -}}
{{- if (and .Values.image.registry .Values.image.repository) }}
repository: {{ printf "%s/%s" .Values.image.registry .Values.image.repository }}
{{- else if .Values.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.image.repository }}
{{- end }}
{{- if .Values.image.tag }}
tag: {{ .Values.image.tag }}
{{- end }}
{{- if .Values.image.pullPolicy }}
pullPolicy: {{ .Values.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Trust Manager Default Package.
*/}}
{{- define "defaultPackage.image" -}}
{{- if (and .Values.defaultPackage.image.registry .Values.defaultPackage.image.repository) }}
repository: {{ printf "%s/%s" .Values.defaultPackage.image.registry .Values.defaultPackage.image.repository }}
{{- else if .Values.defaultPackage.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.defaultPackage.image.repository }}
{{- end }}
{{- if .Values.defaultPackage.image.tag }}
tag: {{ .Values.defaultPackage.image.tag }}
{{- end }}
{{- if .Values.defaultPackage.image.pullPolicy }}
pullPolicy: {{ .Values.defaultPackage.image.pullPolicy }}
{{- end }}
{{- end }}
