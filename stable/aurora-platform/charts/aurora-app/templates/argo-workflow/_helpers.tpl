{{/*
The image section for the Controller component of Argo Workflows.
*/}}
{{- define "argoWorkflow.controller.image" -}}
{{- if .Values.components.argoWorkflow.workflow.controller.image.registry }}
registry: {{ .Values.components.argoWorkflow.workflow.controller.image.registry }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.controller.image.registry }}
repository: {{ .Values.components.argoWorkflow.workflow.controller.image.repository }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.controller.image.tag }}
tag: {{ .Values.components.argoWorkflow.workflow.controller.image.tag }}
{{- end }}
{{- end }}

{{/*
The image section for the Executor component of Argo Workflows.
*/}}
{{- define "argoWorkflow.executor.image" -}}
{{- if .Values.components.argoWorkflow.workflow.executor.image.registry }}
registry: {{ .Values.components.argoWorkflow.workflow.executor.image.registry }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.executor.image.registry }}
repository: {{ .Values.components.argoWorkflow.workflow.executor.image.repository }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.executor.image.tag }}
tag: {{ .Values.components.argoWorkflow.workflow.executor.image.tag }}
{{- end }}
{{- end }}

{{/*
The image section for the Server component of Argo Workflows.
*/}}
{{- define "argoWorkflow.server.image" -}}
{{- if .Values.components.argoWorkflow.workflow.server.image.registry }}
registry: {{ .Values.components.argoWorkflow.workflow.server.image.registry }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.server.image.registry }}
repository: {{ .Values.components.argoWorkflow.workflow.server.image.repository }}
{{- end }}
{{- if .Values.components.argoWorkflow.workflow.server.image.tag }}
tag: {{ .Values.components.argoWorkflow.workflow.server.image.tag }}
{{- end }}
{{- end }}

{{/*
The name of the Argo Workflow namespace.
*/}}
{{- define "argoWorkflow.namespace" -}}
{{- "argo-workflow-system" -}}
{{- end -}}
