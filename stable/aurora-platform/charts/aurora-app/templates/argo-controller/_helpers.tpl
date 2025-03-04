{{/*
The image section for Argo Controller.
*/}}
{{- define "argoController.image" -}}
{{- if (and .Values.components.argoController.image.registry .Values.components.argoController.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.argoController.image.registry .Values.components.argoController.image.repository }}
{{- else if .Values.components.argoController.image.repository }}
repository: {{ printf "%s/%s" (default "ghcr.io" .Values.global.container.registry) .Values.components.argoController.image.repository }}
{{- end }}
{{- if .Values.components.argoController.image.tag }}
tag: {{ .Values.components.argoController.image.tag }}
{{- end }}
{{- if .Values.components.argoController.image.pullPolicy }}
pullPolicy: {{ .Values.components.argoController.image.pullPolicy }}
{{- end }}
{{- end }}

{{- define "argoController.userInterfaceClusterRoleName" -}}
{{- "argo-workflows-namespace" }}
{{- end }}

{{- define "argoController.argoWorkflowsClusterRoleName" -}}
{{- "argo-workflows-workflows" }}
{{- end }}
