{{/*
The image section for Kubecost Frontend.
*/}}
{{- define "kubecost.frontend.image" -}}
{{- if (and .Values.components.kubecost.frontend.image.registry .Values.components.kubecost.frontend.image.repository) }}
image: {{ printf "%s/%s" .Values.components.kubecost.frontend.image.registry .Values.components.kubecost.frontend.image.repository }}
{{- else if .Values.components.kubecost.frontend.image.repository }}
image: {{ printf "%s/%s" (default "gcr.io" .Values.global.container.registry) .Values.components.kubecost.frontend.image.repository }}
{{- end }}
{{- if .Values.components.kubecost.frontend.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.kubecost.frontend.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Kubecost Cost Model.
*/}}
{{- define "kubecost.costModel.image" -}}
{{- if (and .Values.components.kubecost.costModel.image.registry .Values.components.kubecost.costModel.image.repository) }}
image: {{ printf "%s/%s" .Values.components.kubecost.costModel.image.registry .Values.components.kubecost.costModel.image.repository }}
{{- else if .Values.components.kubecost.costModel.image.repository }}
image: {{ printf "%s/%s" (default "gcr.io" .Values.global.container.registry) .Values.components.kubecost.costModel.image.repository }}
{{- end }}
{{- if .Values.components.kubecost.costModel.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.kubecost.costModel.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Kubecost Network Costs.
*/}}
{{- define "kubecost.networkCosts.image" -}}
{{- if (and .Values.components.kubecost.networkCosts.image.registry .Values.components.kubecost.networkCosts.image.repository) }}
image: {{ printf "%s/%s" .Values.components.kubecost.networkCosts.image.registry .Values.components.kubecost.networkCosts.image.repository }}
{{- else if .Values.components.kubecost.networkCosts.image.repository }}
image: {{ printf "%s/%s" (default "gcr.io" .Values.global.container.registry) .Values.components.kubecost.networkCosts.image.repository }}
{{- end }}
{{- if .Values.components.kubecost.networkCosts.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.kubecost.networkCosts.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Kubecost Cluster Controller.
*/}}
{{- define "kubecost.clusterController.image" -}}
{{- if (and .Values.components.kubecost.clusterController.image.registry .Values.components.kubecost.clusterController.image.repository) }}
image: {{ printf "%s/%s" .Values.components.kubecost.clusterController.image.registry .Values.components.kubecost.clusterController.image.repository }}
{{- else if .Values.components.kubecost.clusterController.image.repository }}
image: {{ printf "%s/%s" (default "gcr.io" .Values.global.container.registry) .Values.components.kubecost.clusterController.image.repository }}
{{- end }}
{{- if .Values.components.kubecost.clusterController.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.kubecost.clusterController.image.pullPolicy }}
{{- end }}
{{- end }}
