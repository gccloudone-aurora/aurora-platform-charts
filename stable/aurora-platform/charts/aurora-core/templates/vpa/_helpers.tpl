{{/*
The image section for the VPA Recommender.
*/}}
{{- define "vpa.recommender.image" -}}
{{- if (and .Values.components.vpa.images.recommender.registry .Values.components.vpa.images.recommender.repository) }}
repository: {{ printf "%s/%s" .Values.components.vpa.images.recommender.registry .Values.components.vpa.images.recommender.repository }}
{{- else if .Values.components.vpa.images.recommender.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.vpa.images.recommender.repository }}
{{- end }}
{{- if .Values.components.vpa.images.recommender.tag }}
tag: {{ .Values.components.vpa.images.recommender.tag }}
{{- end }}
{{- if .Values.components.vpa.images.recommender.pullPolicy }}
pullPolicy: {{ .Values.components.vpa.images.recommender.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the VPA Updater.
*/}}
{{- define "vpa.updater.image" -}}
{{- if (and .Values.components.vpa.images.updater.registry .Values.components.vpa.images.updater.repository) }}
repository: {{ printf "%s/%s" .Values.components.vpa.images.updater.registry .Values.components.vpa.images.updater.repository }}
{{- else if .Values.components.vpa.images.updater.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.vpa.images.updater.repository }}
{{- end }}
{{- if .Values.components.vpa.images.updater.tag }}
tag: {{ .Values.components.vpa.images.updater.tag }}
{{- end }}
{{- if .Values.components.vpa.images.updater.pullPolicy }}
pullPolicy: {{ .Values.components.vpa.images.updater.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the VPA Admission Controller.
*/}}
{{- define "vpa.admissionController.image" -}}
{{- if (and .Values.components.vpa.images.admissionController.registry .Values.components.vpa.images.admissionController.repository) }}
repository: {{ printf "%s/%s" .Values.components.vpa.images.admissionController.registry .Values.components.vpa.images.admissionController.repository }}
{{- else if .Values.components.vpa.images.admissionController.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.vpa.images.admissionController.repository }}
{{- end }}
{{- if .Values.components.vpa.images.admissionController.tag }}
tag: {{ .Values.components.vpa.images.admissionController.tag }}
{{- end }}
{{- if .Values.components.vpa.images.admissionController.pullPolicy }}
pullPolicy: {{ .Values.components.vpa.images.admissionController.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the Metrics Server (VPA dependency).
*/}}
{{- define "vpa.metricsServer.image" -}}
{{- if (and .Values.components.vpa.metricsServer.image.registry .Values.components.vpa.metricsServer.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.vpa.metricsServer.image.registry .Values.components.vpa.metricsServer.image.repository }}
{{- else if .Values.components.vpa.metricsServer.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.vpa.metricsServer.image.repository }}
{{- end }}
{{- if .Values.components.vpa.metricsServer.image.tag }}
tag: {{ .Values.components.vpa.metricsServer.image.tag }}
{{- end }}
{{- if .Values.components.vpa.metricsServer.image.pullPolicy }}
pullPolicy: {{ .Values.components.vpa.metricsServer.image.pullPolicy }}
{{- end }}
{{- end }}
