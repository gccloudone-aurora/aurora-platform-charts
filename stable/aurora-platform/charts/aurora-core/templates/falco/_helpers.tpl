{{/*
The image section for the Falco image.
*/}}
{{- define "falco.image" -}}
{{- if (and .Values.components.falco.images.falco.registry .Values.components.falco.images.falco.image.repository) }}
registry: {{ .Values.components.falco.images.falco.image.registry }}
repository: {{ .Values.components.falco.images.falco.image.repository }}
{{- else if .Values.components.falco.images.falco.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falco.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falco.image.tag }}
tag: {{ .Values.components.falco.images.falco.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falco.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falco.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the Falco Sidekick image.
*/}}
{{- define "falcosidekick.image" -}}
{{- if (and .Values.components.falco.images.falcoSideKick.image.registry .Values.components.falco.images.falcoSideKick.image.repository) }}
registry: {{ .Values.components.falco.images.falcoSideKick.image.registry }}
repository: {{ .Values.components.falco.images.falcoSideKick.image.repository }}
{{- else if .Values.components.falco.images.falcoSideKick.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falcoSideKick.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falcoSideKick.image.tag }}
tag: {{ .Values.components.falco.images.falcoSideKick.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falcoSideKick.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falcoSideKick.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the Falco Driver Loader image.
*/}}
{{- define "falcodriverloader.image" -}}
{{- if (and .Values.components.falco.images.falcoDriverLoader.image.registry .Values.components.falco.images.falcoDriverLoader.image.repository) }}
registry: {{ .Values.components.falco.images.falcoDriverLoader.image.registry }}
repository: {{ .Values.components.falco.images.falcoDriverLoader.image.repository }}
{{- else if .Values.components.falco.images.falcoDriverLoader.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falcoDriverLoader.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falcoDriverLoader.image.tag }}
tag: {{ .Values.components.falco.images.falcoDriverLoader.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falcoDriverLoader.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falcoDriverLoader.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the falcoctl image.
*/}}
{{- define "falcoctl.image" -}}
{{- if (and .Values.components.falco.images.falcoctl.image.registry .Values.components.falco.images.falcoctl.image.repository) }}
registry: {{ .Values.components.falco.images.falcoctl.image.registry }}
repository: {{ .Values.components.falco.images.falcoctl.image.repository }}
{{- else if .Values.components.falco.images.falcoctl.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falcoctl.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falcoctl.image.tag }}
tag: {{ .Values.components.falco.images.falcoctl.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falcoctl.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falcoctl.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the k8s-metacollector image.
*/}}
{{- define "k8smetacollector.image" -}}
{{- if (and .Values.components.falco.images.k8sMetacollector.image.registry .Values.components.falco.images.k8sMetacollector.image.repository) }}
registry: {{ .Values.components.falco.images.k8sMetacollector.image.registry }}
repository: {{ .Values.components.falco.images.k8sMetacollector.image.repository }}
{{- else if .Values.components.falco.images.k8sMetacollector.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.k8sMetacollector.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.k8sMetacollector.image.tag }}
tag: {{ .Values.components.falco.images.k8sMetacollector.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.k8sMetacollector.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.k8sMetacollector.image.pullPolicy }}
{{- end }}
{{- end }}
