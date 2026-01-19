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

{{/*
The azureWorkloadIdentity configuration.
*/}}
{{- define "argoSolution.argocdInstance.azureWorkloadIdentity.clientId" -}}
{{- if .Values.components.argoSolution.argocdInstance.azureWorkloadIdentity.enabled -}}
azure.workload.identity/client-id: {{ required "argoSolution.argocdInstance.azureWorkloadIdentity.clientId is required" .Values.components.argoSolution.argocdInstance.azureWorkloadIdentity.clientId | quote }}
{{- end }}
{{- end }}