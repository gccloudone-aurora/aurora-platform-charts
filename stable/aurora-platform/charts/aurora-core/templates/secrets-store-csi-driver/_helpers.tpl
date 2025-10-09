{{/*
The image section for the driver image.
*/}}
{{- define "driver.image" -}}
{{- if (and .Values.components.secretsStoreCSIDriver.images.driver.registry .Values.components.secretsStoreCSIDriver.images.driver.image.repository) }}
repository: "{{ .Values.components.secretsStoreCSIDriver.images.driver.image.registry }}/{{ .Values.components.secretsStoreCSIDriver.images.driver.image.repository }}"
{{- else if .Values.components.secretsStoreCSIDriver.images.driver.image.repository }}
repository: "{{ (default "registry.k8s.io" .Values.global.container.registry) }}/{{ .Values.components.secretsStoreCSIDriver.images.driver.image.repository }}"
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.driver.image.tag }}
tag: {{ .Values.components.secretsStoreCSIDriver.images.driver.image.tag }}
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.driver.image.pullPolicy }}
pullPolicy: {{ .Values.components.secretsStoreCSIDriver.images.driver.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the CRDs image.
*/}}
{{- define "crds.image" -}}
{{- if (and .Values.components.secretsStoreCSIDriver.images.crds.image.registry .Values.components.secretsStoreCSIDriver.images.crds.image.repository) }}
repository: "{{ .Values.components.secretsStoreCSIDriver.images.crds.image.registry }}/{{ .Values.components.secretsStoreCSIDriver.images.crds.image.repository }}"
{{- else if .Values.components.secretsStoreCSIDriver.images.crds.image.repository }}
repository: "{{ (default "registry.k8s.io" .Values.global.container.registry) }}/{{ .Values.components.secretsStoreCSIDriver.images.crds.image.repository }}"
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.crds.image.tag }}
tag: {{ .Values.components.secretsStoreCSIDriver.images.crds.image.tag }}
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.crds.image.pullPolicy }}
pullPolicy: {{ .Values.components.secretsStoreCSIDriver.images.crds.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the Registrar image.
*/}}
{{- define "registrar.image" -}}
{{- if (and .Values.components.secretsStoreCSIDriver.images.registrar.image.registry .Values.components.secretsStoreCSIDriver.images.registrar.image.repository) }}
repository: "{{ .Values.components.secretsStoreCSIDriver.images.registrar.image.registry }}/{{ .Values.components.secretsStoreCSIDriver.images.registrar.image.repository }}"
{{- else if .Values.components.secretsStoreCSIDriver.images.registrar.image.repository }}
repository: "{{ (default "registry.k8s.io" .Values.global.container.registry) }}/{{ .Values.components.secretsStoreCSIDriver.images.registrar.image.repository }}"
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.registrar.image.tag }}
tag: {{ .Values.components.secretsStoreCSIDriver.images.registrar.image.tag }}
{{- end }}
{{- if .Values.components.secretsStoreCSIDriver.images.registrar.image.pullPolicy }}
pullPolicy: {{ .Values.components.secretsStoreCSIDriver.images.registrar.image.pullPolicy }}
{{- end }}
{{- end }}
