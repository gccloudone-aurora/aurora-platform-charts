{{/*
The image section for AAD Pod Identity.
*/}}
{{- define "aad-pod-identity.image" -}}
{{- if (and .Values.components.aadPodIdentity.image.registry .Values.components.aadPodIdentity.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.aadPodIdentity.image.registry .Values.components.aadPodIdentity.image.repository }}
{{- else if .Values.components.aadPodIdentity.image.repository }}
repository: {{ printf "%s/%s" (default "mcr.microsoft.com" .Values.global.container.registry) .Values.components.aadPodIdentity.image.repository }}
{{- end }}
{{- if .Values.components.aadPodIdentity.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.aadPodIdentity.image.pullPolicy }}
{{- end }}
{{- end }}
