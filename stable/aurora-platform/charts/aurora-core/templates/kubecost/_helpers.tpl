{{/*  FinOps Agent Image Fields */}}
{{- define "kubecost.finopsagent.image" -}}
registry: {{ .Values.components.kubecost.finopsagent.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.finopsagent.image.repository | default "ibm-finops/agent" | quote }}
tag: {{ .Values.components.kubecost.finopsagent.image.tag | default "" | toString | quote }}
pullPolicy: {{ .Values.components.kubecost.finopsagent.image.pullPolicy | default "IfNotPresent" | quote }}
{{- end -}}

{{/*  Aggregator Image Fields */}}
{{- define "kubecost.aggregator.image" -}}
registry: {{ .Values.components.kubecost.aggregator.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.aggregator.image.repository | default "kubecost/cost-model" | quote }}
tag: {{ .Values.components.kubecost.aggregator.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  CloudCost Image Fields */}}
{{- define "kubecost.cloudCost.image" -}}
registry: {{ .Values.components.kubecost.cloudCost.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.cloudCost.image.repository | default "kubecost/cost-model" | quote }}
tag: {{ .Values.components.kubecost.cloudCost.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  localStore Image */}}
{{- define "kubecost.localStore.image" -}}
registry: {{ .Values.components.kubecost.localStore.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.localStore.image.repository | default "kubecost/cost-model" | quote }}
tag: {{ .Values.components.kubecost.localStore.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  clusterController Image */}}
{{- define "kubecost.clusterController.image" -}}
registry: {{ .Values.components.kubecost.clusterController.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.clusterController.image.repository | default "kubecost/cluster-controller" | quote }}
tag: {{ .Values.components.kubecost.clusterController.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  frontend Image */}}
{{- define "kubecost.frontend.image" -}}
registry: {{ .Values.components.kubecost.frontend.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.frontend.image.repository | default "kubecost/frontend" | quote }}
tag: {{ .Values.components.kubecost.frontend.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  forecasting Image */}}
{{- define "kubecost.forecasting.image" -}}
registry: {{ .Values.components.kubecost.forecasting.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.forecasting.image.repository | default "kubecost/modeling" | quote }}
tag: {{ .Values.components.kubecost.forecasting.image.tag | default "" | toString | quote }}
{{- end -}}

{{/*  networkCosts Image */}}
{{- define "kubecost.networkCosts.image" -}}
registry: {{ .Values.components.kubecost.networkCosts.image.registry | default .Values.global.container.registry | default "icr.io" | quote }}
repository: {{ .Values.components.kubecost.networkCosts.image.repository | default "kubecost/network-costs" | quote }}
tag: {{ .Values.components.kubecost.networkCosts.image.tag | default "" | toString | quote }}
{{- end -}}
