{{/*
The image section for Loki.
*/}}
{{- define "loki.image" -}}
{{- if (and .Values.components.loki.image.registry .Values.components.loki.image.repository) }}
registry: {{ .Values.components.loki.image.registry }}
repository: {{ .Values.components.loki.image.repository }}
{{- else if .Values.components.loki.image.repository }}
registry: {{ default "docker.io" .Values.global.container.registry }}
repository: {{ .Values.components.loki.image.repository }}
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
accountName: {{ required "loki.logStorageLocation.storageAccountName is required" .Values.components.loki.logStorageLocation.storageAccountName | quote }}
accountKey: {{ required "loki.logStorageLocation.storageAccountKey is required" .Values.components.loki.logStorageLocation.storageAccountKey | quote }}
requestTimeout: 0
{{- end }}
{{- end }}
