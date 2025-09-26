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
{{- if (and .Values.components.falco.images.falcosidekick.image.registry .Values.components.falco.images.falcosidekick.image.repository) }}
registry: {{ .Values.components.falco.images.falcosidekick.image.registry }}
repository: {{ .Values.components.falco.images.falcosidekick.image.repository }}
{{- else if .Values.components.falco.images.falcosidekick.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falcosidekick.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falcosidekick.image.tag }}
tag: {{ .Values.components.falco.images.falcosidekick.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falcosidekick.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falcosidekick.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for the Falco Driver Loader image.
*/}}
{{- define "falcodriverloader.image" -}}
{{- if (and .Values.components.falco.images.falcodriverloader.image.registry .Values.components.falco.images.falcodriverloader.image.repository) }}
registry: {{ .Values.components.falco.images.falcoctl.image.registry }}
repository: {{ .Values.components.falco.images.falcodriverloader.image.repository }}
{{- else if .Values.components.falco.images.falcodriverloader.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.falcodriverloader.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.falcodriverloader.image.tag }}
tag: {{ .Values.components.falco.images.falcodriverloader.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.falcodriverloader.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.falcodriverloader.image.pullPolicy }}
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
{{- if (and .Values.components.falco.images.k8smetacollector.image.registry .Values.components.falco.images.k8smetacollector.image.repository) }}
registry: {{ .Values.components.falco.images.k8smetacollector.image.registry }}
repository: {{ .Values.components.falco.images.k8smetacollector.image.repository }}
{{- else if .Values.components.falco.images.k8smetacollector.image.repository }}
registry: {{ (default "docker.io" .Values.global.container.registry) }}
repository: {{ .Values.components.falco.images.k8smetacollector.image.repository }}
{{- end }}
{{- if .Values.components.falco.images.k8smetacollector.image.tag }}
tag: {{ .Values.components.falco.images.k8smetacollector.image.tag }}
{{- end }}
{{- if .Values.components.falco.images.k8smetacollector.image.pullPolicy }}
pullPolicy: {{ .Values.components.falco.images.k8smetacollector.image.pullPolicy }}
{{- end }}
{{- end }}
