{{/*
The image section for Fluent Operator.
*/}}
{{- define "fluentOperator.operator.image" -}}
{{- if (and .Values.components.fluentOperator.operator.image.registry .Values.components.fluentOperator.operator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.fluentOperator.operator.image.registry .Values.components.fluentOperator.operator.image.repository }}
{{- else if .Values.components.fluentOperator.operator.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.fluentOperator.operator.image.repository }}
{{- end }}
{{- if .Values.components.fluentOperator.operator.image.tag }}
tag: {{ .Values.components.fluentOperator.operator.image.tag }}
{{- end }}
{{- if .Values.components.fluentOperator.operator.image.pullPolicy }}
pullPolicy: {{ .Values.components.fluentOperator.operator.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Fluent Operator initContainer.
*/}}
{{- define "fluentOperator.operator.initContainer.image" -}}
{{- if (and .Values.components.fluentOperator.operator.initContainer.image.registry .Values.components.fluentOperator.operator.initContainer.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.fluentOperator.operator.initContainer.image.registry .Values.components.fluentOperator.operator.initContainer.image.repository }}
{{- else if .Values.components.fluentOperator.operator.initContainer.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.fluentOperator.operator.initContainer.image.repository }}
{{- end }}
{{- if .Values.components.fluentOperator.operator.initContainer.image.tag }}
tag: {{ .Values.components.fluentOperator.operator.initContainer.image.tag | quote }}
{{- end }}
{{- if .Values.components.fluentOperator.operator.initContainer.image.pullPolicy }}
pullPolicy: {{ .Values.components.fluentOperator.operator.initContainer.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Fluent Operator Fluentbit.
*/}}
{{- define "fluentOperator.fluentbit.image" -}}
{{- if (and .Values.components.fluentOperator.fluentbit.image.registry .Values.components.fluentOperator.fluentbit.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.fluentOperator.fluentbit.image.registry .Values.components.fluentOperator.fluentbit.image.repository }}
{{- else if .Values.components.fluentOperator.fluentbit.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.fluentOperator.fluentbit.image.repository }}
{{- end }}
{{- if .Values.components.fluentOperator.fluentbit.image.tag }}
tag: {{ .Values.components.fluentOperator.fluentbit.image.tag }}
{{- end }}
{{- if .Values.components.fluentOperator.fluentbit.image.pullPolicy }}
pullPolicy: {{ .Values.components.fluentOperator.fluentbit.image.pullPolicy }}
{{- end }}
{{- end }}
{{/*
The image section for Kind Fluentd.
Specific sha for v1.15.3 to resolve upstream issue https://github.com/fluent/fluent-operator/issues/1187
*/}}
{{- define "fluentOperator.kindFluentd.image" -}}
{{- if (and .Values.components.fluentOperator.fluentd.image.repository .Values.components.fluentOperator.fluentd.image.tag) }}
{{- printf "%s/%s:%s" (default "docker.io" .Values.global.container.registry) .Values.components.fluentOperator.fluentd.image.repository .Values.components.fluentOperator.fluentd.image.tag }}
{{- else if .Values.components.fluentOperator.fluentd.image.repository }}
{{- printf "%s/%s:%s" (default "docker.io" .Values.global.container.registry) .Values.components.fluentOperator.fluentd.image.repository "v1.15.3@sha256:794311919658aee8eb9829836cd6c3437dffd9c7112556d5dc2f01ca3fcb826b" }}
{{- else }}
{{- printf "%s/%s:%s" (default "docker.io" .Values.global.container.registry) "kubesphere/fluentd" "v1.15.3@sha256:794311919658aee8eb9829836cd6c3437dffd9c7112556d5dc2f01ca3fcb826b" }}
{{- end }}
{{- end }}
