{{/*
The image section for velero.
*/}}
{{- define "velero.image" -}}
{{- if (and .Values.components.velero.image.registry .Values.components.velero.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.velero.image.registry .Values.components.velero.image.repository }}
{{- else if .Values.components.velero.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.velero.image.repository }}
{{- end }}
{{- if .Values.components.velero.image.tag }}
tag: {{ .Values.components.velero.image.tag }}
{{- end }}
{{- if .Values.components.velero.image.pullPolicy }}
pullPolicy: {{ .Values.components.velero.image.pullPolicy }}
{{- end }}
{{- if .Values.components.velero.imagePullSecrets }}
pullSecrets:
  {{- toYaml .Values.components.velero.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The image section for kubectl.
*/}}
{{- define "velero.kubectl.image" -}}
{{- if (and .Values.components.velero.kubectl.image.registry .Values.components.velero.kubectl.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.velero.kubectl.image.registry .Values.components.velero.kubectl.image.repository }}
{{- else if .Values.components.velero.kubectl.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.velero.kubectl.image.repository }}
{{- end }}
{{- if .Values.components.velero.kubectl.image.tag }}
tag: {{ .Values.components.velero.kubectl.image.tag }}
{{- end }}
{{- end }}

{{/*
The image section for velero plugins.
*/}}
{{- define "velero.plugin.image" -}}
  {{- $provider := .Values.global.provider -}}
  {{- $plugin := index .Values.components.velero.plugins $provider | default dict -}}
  {{- $image := $plugin.image | default dict -}}
  {{- $registry := coalesce $image.registry .Values.global.container.registry "docker.io" -}}
  {{- $repository := required (printf "Missing velero.plugin.image.repository for provider '%s'" $provider) $image.repository -}}
  {{- $tag := default "latest" $image.tag -}}
  {{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end }}

{{/*
The backupStorageLocation configuration.
*/}}
{{- define "velero.backupStorageLocation.config" -}}
{{- if eq .Values.global.provider "azure" }}
resourceGroup: {{ required "velero.backupStorage.resourceGroupName is required" .Values.components.velero.backupStorage.resourceGroupName | quote }}
storageAccount: {{ required "velero.backupStorage.storageAccountName is required" .Values.components.velero.backupStorage.storageAccountName | quote }}
subscriptionId: {{ required "velero.backupStorage.subscriptionId is required" .Values.components.velero.backupStorage.subscriptionId | quote }}
{{- else if eq .Values.global.provider "aws" }}
region: ca-central-1
{{- end }}
{{- end }}

{{/*
The volumeSnapshotLocation configuration.
*/}}
{{- define "velero.volumeSnapshotLocation.config" -}}
{{- if eq .Values.global.provider "azure" }}
resourceGroup: {{ required "velero.volumeSnapshot.resourceGroupName is required" .Values.components.velero.volumeSnapshot.resourceGroupName | quote }}
incremental: true
{{- else if eq .Values.global.provider "aws" }}
region: ca-central-1
{{- end }}
{{- end }}
