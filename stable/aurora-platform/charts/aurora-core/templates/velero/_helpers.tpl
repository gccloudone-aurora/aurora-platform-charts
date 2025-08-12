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
{{- define "velero.imageFunction" -}}
{{- if .image.registry }}
{{- printf "%s/%s:%s" .image.registry .image.repository .image.tag }}
{{- else }}
{{- printf "%s/%s:%s" "docker.io" .image.repository .image.tag }}
{{- end }}
{{- end }}
