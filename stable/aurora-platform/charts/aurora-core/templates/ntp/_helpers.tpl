{{/*
The image section for ntp.
*/}}
{{- define "ntp.image" -}}
{{- if (and .Values.components.ntp.image.registry .Values.components.ntp.image.repository .Values.components.ntp.image.tag) }}
{{- printf "%s/%s:%s" .Values.components.ntp.image.registry .Values.components.ntp.image.repository .Values.components.ntp.image.tag }}
{{- else if (and .Values.components.ntp.image.repository .Values.components.ntp.image.tag) }}
{{- printf "%s/%s:%s" (default "docker.io" .Values.global.container.registry) .Values.components.ntp.image.repository .Values.components.ntp.image.tag }}
{{- else }}
{{- printf "%s/%s:%s" "docker.io" "busybox" "latest" }}
{{- end }}
{{- end }}
