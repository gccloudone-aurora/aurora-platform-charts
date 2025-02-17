{{/*
The image section for Argo Operator.
*/}}
{{- define "argoOperator.image" -}}
{{- if (and .Values.components.argoOperator.image.registry .Values.components.argoOperator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.argoOperator.image.registry .Values.components.argoOperator.image.repository }}
{{- else if .Values.components.argoOperator.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.argoOperator.image.repository }}
{{- end }}
{{- if .Values.components.argoOperator.image.tag }}
tag: {{ .Values.components.argoOperator.image.tag }}
{{- end }}
{{- if .Values.components.argoOperator.image.pullPolicy }}
pullPolicy: {{ .Values.components.argoOperator.image.pullPolicy }}
{{- end }}
{{- end }}
