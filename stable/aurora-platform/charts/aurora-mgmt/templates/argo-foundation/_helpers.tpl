{{/*
The image section for Argo Foundation.
*/}}
{{- define "argoFoundation.image" -}}
{{- if (and .Values.components.argoFoundation.image.registry .Values.components.argoFoundation.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.argoFoundation.image.registry .Values.components.argoFoundation.image.repository }}
{{- else if .Values.components.argoFoundation.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.argoFoundation.image.repository }}
{{- end }}
{{- if .Values.components.argoFoundation.image.tag }}
tag: {{ .Values.components.argoFoundation.image.tag }}
{{- end }}
{{- if .Values.components.argoFoundation.image.pullPolicy }}
pullPolicy: {{ .Values.components.argoFoundation.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The azureWorkloadIdentity configuration.
*/}}
{{- define "argoFoundation.argocdInstance.azureWorkloadIdentity.clientId" -}}
{{- if .Values.components.argoFoundation.argocdInstance.azureWorkloadIdentity.enabled -}}
azure.workload.identity/client-id: {{ required "argoFoundation.argocdInstance.azureWorkloadIdentity.clientId is required" .Values.components.argoFoundation.argocdInstance.azureWorkloadIdentity.clientId | quote }}
{{- end }}
{{- end }}