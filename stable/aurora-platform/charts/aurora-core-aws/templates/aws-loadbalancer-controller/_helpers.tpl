{{/*
The image section for Argo Controller.
*/}}
{{- define "awsLoadbalancerController.image" -}}
{{- if (and .Values.components.awsLoadbalancerController.image.registry .Values.components.awsLoadbalancerController.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsLoadbalancerController.image.registry .Values.components.awsLoadbalancerController.image.repository }}
{{- else if .Values.components.awsLoadbalancerController.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsLoadbalancerController.image.repository }}
{{- end }}
{{- if .Values.components.awsLoadbalancerController.image.tag }}
tag: {{ .Values.components.awsLoadbalancerController.image.tag }}
{{- end }}
{{- if .Values.components.awsLoadbalancerController.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsLoadbalancerController.image.pullPolicy }}
{{- end }}
{{- end }}