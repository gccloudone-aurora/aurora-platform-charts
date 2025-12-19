{{/*
The image section for kubebench.
*/}}
{{- define "kubebench.image" -}}
{{- if (and .Values.components.kubebench.image.registry .Values.components.kubebench.image.repository .Values.components.kubebench.image.tag) }}
{{- printf "%s/%s:%s" .Values.components.kubebench.image.registry .Values.components.kubebench.image.repository .Values.components.kubebench.image.tag }}
{{- else if (and .Values.components.kubebench.image.repository .Values.components.kubebench.image.tag) }}
{{- printf "%s/%s:%s" (default "docker.io" .Values.global.container.registry) .Values.components.kubebench.image.repository .Values.components.kubebench.image.tag }}
{{- else }}
{{- printf "%s/%s:%s" "docker.io" "busybox" "latest" }}
{{- end }}
{{- end }}

{{/*
The cronjob command section based on cloud provider
*/}}
{{- define "cronjob.command" -}}
{{- if ne (join "" .Values.components.kubebench.cronjob.command) "" -}}
{{ toJson .Values.components.kubebench.cronjob.command }}
{{- else -}}
{{- if eq "azure" .Values.global.provider -}}
["kube-bench", "--benchmark", "aks-1.0", "run", "--targets", "node"]
{{- else if eq "aws" .Values.global.provider -}}
["kube-bench", "--benchmark", "eks-1.1.0", "run", "--targets", "node"]
{{- else -}}
["kube-bench"]
{{- end }}
{{- end -}}
{{- end -}}