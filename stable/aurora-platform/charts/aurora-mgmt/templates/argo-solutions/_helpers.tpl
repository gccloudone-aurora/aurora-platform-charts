{{/*
The image section for Argo Solution.
*/}}
{{- define "argoSolution.image" -}}
{{- if (and .Values.components.argoSolution.image.registry .Values.components.argoSolution.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.argoSolution.image.registry .Values.components.argoSolution.image.repository }}
{{- else if .Values.components.argoSolution.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.argoSolution.image.repository }}
{{- end }}
{{- if .Values.components.argoSolution.image.tag }}
tag: {{ .Values.components.argoSolution.image.tag }}
{{- end }}
{{- if .Values.components.argoSolution.image.pullPolicy }}
pullPolicy: {{ .Values.components.argoSolution.image.pullPolicy }}
{{- end }}
{{- end }}
