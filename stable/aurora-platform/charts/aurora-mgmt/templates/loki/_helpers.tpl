{{/*
The image section for Loki.
*/}}
{{- define "loki.image" -}}
{{- if (and .Values.components.loki.image.registry .Values.components.loki.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.loki.image.registry .Values.components.loki.image.repository }}
{{- else if .Values.components.loki.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.loki.image.repository }}
{{- end }}
{{- if .Values.components.loki.image.tag }}
tag: {{ .Values.components.loki.image.tag }}
{{- end }}
{{- if .Values.components.loki.image.pullPolicy }}
pullPolicy: {{ .Values.components.loki.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The logStorageLocation configuration.
*/}}
{{- define "loki.logStorageLocation" -}}
{{- if eq .Values.global.provider "azure" }}
azure:
  storageAccountName: {{ required "loki.logStorageLocation.storageAccountName is required" .Values.components.loki.logStorageLocation.storageAccountName | quote }}
  storageAccountKey: {{ required "loki.logStorageLocation.storageAccountKey is required" .Values.components.loki.logStorageLocation.storageAccountKey | quote }}
  requestTimeout: 0
{{- end }}
{{- end }}
