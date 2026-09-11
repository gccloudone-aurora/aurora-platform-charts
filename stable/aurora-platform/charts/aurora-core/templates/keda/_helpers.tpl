{{/*
The image section for the KEDA Operator.
*/}}
{{- define "keda.image" -}}
{{- if (and .Values.components.keda.images.keda.image.registry .Values.components.keda.images.keda.image.repository) }}
registry: {{ .Values.components.keda.images.keda.image.registry }}
repository: {{ .Values.components.keda.images.keda.image.repository }}
{{- else if .Values.components.keda.images.keda.image.repository }}
registry: {{ (default "ghcr.io" .Values.global.container.registry) }}
repository: {{ .Values.components.keda.images.keda.image.repository }}
{{- end }}
{{- if .Values.components.keda.images.keda.image.tag }}
tag: {{ .Values.components.keda.images.keda.image.tag }}
{{- end }}
{{- if .Values.components.keda.images.keda.image.pullPolicy }}
pullPolicy: {{ .Values.components.keda.images.keda.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the KEDA Metrics API Server.
*/}}
{{- define "keda.metricsApiServer.image" -}}
{{- if (and .Values.components.keda.images.metricsApiServer.image.registry .Values.components.keda.images.metricsApiServer.image.repository) }}
registry: {{ .Values.components.keda.images.metricsApiServer.image.registry }}
repository: {{ .Values.components.keda.images.metricsApiServer.image.repository }}
{{- else if .Values.components.keda.images.metricsApiServer.image.repository }}
registry: {{ (default "ghcr.io" .Values.global.container.registry) }}
repository: {{ .Values.components.keda.images.metricsApiServer.image.repository }}
{{- end }}
{{- if .Values.components.keda.images.metricsApiServer.image.tag }}
tag: {{ .Values.components.keda.images.metricsApiServer.image.tag }}
{{- end }}
{{- if .Values.components.keda.images.metricsApiServer.image.pullPolicy }}
pullPolicy: {{ .Values.components.keda.images.metricsApiServer.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the KEDA Admission Webhooks.
*/}}
{{- define "keda.webhooks.image" -}}
{{- if (and .Values.components.keda.images.webhooks.image.registry .Values.components.keda.images.webhooks.image.repository) }}
registry: {{ .Values.components.keda.images.webhooks.image.registry }}
repository: {{ .Values.components.keda.images.webhooks.image.repository }}
{{- else if .Values.components.keda.images.webhooks.image.repository }}
registry: {{ (default "ghcr.io" .Values.global.container.registry) }}
repository: {{ .Values.components.keda.images.webhooks.image.repository }}
{{- end }}
{{- if .Values.components.keda.images.webhooks.image.tag }}
tag: {{ .Values.components.keda.images.webhooks.image.tag }}
{{- end }}
{{- if .Values.components.keda.images.webhooks.image.pullPolicy }}
pullPolicy: {{ .Values.components.keda.images.webhooks.image.pullPolicy }}
{{- end }}
{{- end }}
