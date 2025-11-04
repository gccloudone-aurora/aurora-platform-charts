{{/*
The image section for Argo Foundation.
*/}}
{{- define "argocdSolutions.image" -}}
{{- if (and .Values.components.argocdSolutions.image.registry .Values.components.argocdSolutions.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.argocdSolutions.image.registry .Values.components.argocdSolutions.image.repository }}
{{- else if .Values.components.argocdSolutions.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.argocdSolutions.image.repository }}
{{- end }}
{{- if .Values.components.argocdSolutions.image.tag }}
tag: {{ .Values.components.argocdSolutions.image.tag }}
{{- end }}
{{- if .Values.components.argocdSolutions.image.pullPolicy }}
pullPolicy: {{ .Values.components.argocdSolutions.image.pullPolicy }}
{{- end }}
{{- end }}
