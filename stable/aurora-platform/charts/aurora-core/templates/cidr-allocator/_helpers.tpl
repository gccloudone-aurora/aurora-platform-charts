{{/*
The image section for CIDR Allocator.
*/}}
{{- define "cidrAllocator.image" -}}
{{- if (and .Values.components.cidrAllocator.image.registry .Values.components.cidrAllocator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cidrAllocator.image.registry .Values.components.cidrAllocator.image.repository }}
{{- else if .Values.components.cidrAllocator.image.repository }}
repository: {{ printf "%s/%s" (default "artifactory.ssc-spc.gc.ca/docker" .Values.global.container.registry) .Values.components.cidrAllocator.image.repository }}
{{- end }}
{{- if .Values.components.cidrAllocator.image.tag }}
tag: {{ .Values.components.cidrAllocator.image.tag }}
{{- end }}
{{- if .Values.components.cidrAllocator.image.pullPolicy }}
pullPolicy: {{ .Values.components.cidrAllocator.image.pullPolicy }}
{{- end }}
{{- end }}
