{{/*
The image section for the vaultAgent image.
*/}}
{{- define "vaultAgent.injector.image" -}}
{{- if (and .Values.components.vaultAgent.injector.image.registry .Values.components.vaultAgent.injector.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.vaultAgent.injector.image.registry .Values.components.vaultAgent.injector.image.repository }}
{{- else if .Values.components.vaultAgent.injector.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.vaultAgent.injector.image.repository }}
{{- end }}
{{- if .Values.components.vaultAgent.injector.image.tag }}
tag: {{ .Values.components.vaultAgent.injector.image.tag }}
{{- end }}
{{- if .Values.components.vaultAgent.injector.image.pullPolicy }}
pullPolicy: {{ .Values.components.vaultAgent.injector.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the vaultAgent agentImage.
*/}}
{{- define "vaultAgent.injector.agentImage" -}}
{{- if (and .Values.components.vaultAgent.injector.agentImage.registry .Values.components.vaultAgent.injector.agentImage.repository) }}
repository: {{ printf "%s/%s" .Values.components.vaultAgent.injector.agentImage.registry .Values.components.vaultAgent.injector.agentImage.repository }}
{{- else if .Values.components.vaultAgent.injector.agentImage.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.vaultAgent.injector.agentImage.repository }}
{{- end }}
{{- if .Values.components.vaultAgent.injector.agentImage.tag }}
tag: {{ .Values.components.vaultAgent.injector.agentImage.tag }}
{{- end }}
{{- end }}
