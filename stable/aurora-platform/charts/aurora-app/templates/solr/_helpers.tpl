{{/*
The image section for Solr.
*/}}
{{- define "solr.image" -}}
{{- if (and .Values.components.solr.image.registry .Values.components.solr.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.solr.image.registry .Values.components.solr.image.repository }}
{{- else if .Values.components.solr.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.solr.image.repository }}
{{- end }}
{{- if .Values.components.solr.image.tag }}
tag: {{ .Values.components.solr.image.tag }}
{{- end }}
{{- if .Values.components.solr.image.pullPolicy }}
pullPolicy: {{ .Values.components.solr.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Solr ZooKeeper.
*/}}
{{- define "solr.zookeeper.image" -}}
{{- if (and .Values.components.solr.zookeeper.image.registry .Values.components.solr.zookeeper.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.solr.zookeeper.image.registry .Values.components.solr.zookeeper.image.repository }}
{{- else if .Values.components.solr.zookeeper.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.solr.zookeeper.image.repository }}
{{- end }}
{{- if .Values.components.solr.zookeeper.image.tag }}
tag: {{ .Values.components.solr.zookeeper.image.tag }}
{{- end }}
{{- if .Values.components.solr.zookeeper.image.pullPolicy }}
pullPolicy: {{ .Values.components.solr.zookeeper.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Solr ZooKeeper Hooks.
*/}}
{{- define "solr.zookeeper.hooks.image" -}}
{{- if (and .Values.components.solr.zookeeper.hooks.image.registry .Values.components.solr.zookeeper.hooks.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.solr.zookeeper.hooks.image.registry .Values.components.solr.zookeeper.hooks.image.repository }}
{{- else if .Values.components.solr.zookeeper.hooks.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.solr.zookeeper.hooks.image.repository }}
{{- end }}
{{- if .Values.components.solr.zookeeper.hooks.image.tag }}
tag: {{ .Values.components.solr.zookeeper.hooks.image.tag }}
{{- end }}
{{- end }}
