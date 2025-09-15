{{/*
The image section for Trust Manager.
*/}}
{{- define "trustManager.image" -}}
{{- if (and .Values.components.trustManager.image.registry .Values.components.trustManager.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.trustManager.image.registry .Values.components.trustManager.image.repository }}
{{- else if .Values.components.trustManager.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.trustManager.image.repository }}
{{- end }}
{{- if .Values.components.trustManager.image.tag }}
tag: {{ .Values.components.trustManager.image.tag }}
{{- end }}
{{- if .Values.components.trustManager.image.pullPolicy }}
pullPolicy: {{ .Values.components.trustManager.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Trust Manager Default Package.
*/}}
{{- define "trustManager.defaultPackage.image" -}}
{{- if (and .Values.components.trustManager.defaultPackage.image.registry .Values.components.trustManager.defaultPackage.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.trustManager.defaultPackage.image.registry .Values.components.trustManager.defaultPackage.image.repository }}
{{- else if .Values.components.trustManager.defaultPackage.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.trustManager.defaultPackage.image.repository }}
{{- end }}
{{- if .Values.components.trustManager.defaultPackage.image.tag }}
tag: {{ .Values.components.trustManager.defaultPackage.image.tag }}
{{- end }}
{{- if .Values.components.trustManager.defaultPackage.image.pullPolicy }}
pullPolicy: {{ .Values.components.trustManager.defaultPackage.image.pullPolicy }}
{{- end }}
{{- end }}
