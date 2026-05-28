{{/*
Image block for the VPA admission controller.
*/}}
{{- define "verticalPodAutoscaler.admissionController.image" -}}
{{- if (and .Values.components.verticalPodAutoscaler.admissionController.image.registry .Values.components.verticalPodAutoscaler.admissionController.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.verticalPodAutoscaler.admissionController.image.registry .Values.components.verticalPodAutoscaler.admissionController.image.repository }}
{{- else if .Values.components.verticalPodAutoscaler.admissionController.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.verticalPodAutoscaler.admissionController.image.repository }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.admissionController.image.tag }}
tag: {{ .Values.components.verticalPodAutoscaler.admissionController.image.tag }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.admissionController.image.pullPolicy }}
pullPolicy: {{ .Values.components.verticalPodAutoscaler.admissionController.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
Image block for the VPA recommender.
*/}}
{{- define "verticalPodAutoscaler.recommender.image" -}}
{{- if (and .Values.components.verticalPodAutoscaler.recommender.image.registry .Values.components.verticalPodAutoscaler.recommender.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.verticalPodAutoscaler.recommender.image.registry .Values.components.verticalPodAutoscaler.recommender.image.repository }}
{{- else if .Values.components.verticalPodAutoscaler.recommender.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.verticalPodAutoscaler.recommender.image.repository }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.recommender.image.tag }}
tag: {{ .Values.components.verticalPodAutoscaler.recommender.image.tag }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.recommender.image.pullPolicy }}
pullPolicy: {{ .Values.components.verticalPodAutoscaler.recommender.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
Image block for the VPA updater.
*/}}
{{- define "verticalPodAutoscaler.updater.image" -}}
{{- if (and .Values.components.verticalPodAutoscaler.updater.image.registry .Values.components.verticalPodAutoscaler.updater.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.verticalPodAutoscaler.updater.image.registry .Values.components.verticalPodAutoscaler.updater.image.repository }}
{{- else if .Values.components.verticalPodAutoscaler.updater.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.verticalPodAutoscaler.updater.image.repository }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.updater.image.tag }}
tag: {{ .Values.components.verticalPodAutoscaler.updater.image.tag }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.updater.image.pullPolicy }}
pullPolicy: {{ .Values.components.verticalPodAutoscaler.updater.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
Image block for the VPA admission webhook certgen job.
*/}}
{{- define "verticalPodAutoscaler.certGen.image" -}}
{{- if (and .Values.components.verticalPodAutoscaler.admissionController.certGen.image.registry .Values.components.verticalPodAutoscaler.admissionController.certGen.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.verticalPodAutoscaler.admissionController.certGen.image.registry .Values.components.verticalPodAutoscaler.admissionController.certGen.image.repository }}
{{- else if .Values.components.verticalPodAutoscaler.admissionController.certGen.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.verticalPodAutoscaler.admissionController.certGen.image.repository }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.admissionController.certGen.image.tag }}
tag: {{ .Values.components.verticalPodAutoscaler.admissionController.certGen.image.tag }}
{{- end }}
{{- if .Values.components.verticalPodAutoscaler.admissionController.certGen.image.pullPolicy }}
pullPolicy: {{ .Values.components.verticalPodAutoscaler.admissionController.certGen.image.pullPolicy }}
{{- end }}
{{- end }}
