{{/*
The image section for Cilium.
*/}}
{{- define "cilium.image" -}}
{{- if (and .Values.components.cilium.image.registry .Values.components.cilium.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.image.registry .Values.components.cilium.image.repository }}
{{- else if .Values.components.cilium.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.image.repository }}
{{- end }}
{{- if .Values.components.cilium.image.tag }}
tag: {{ .Values.components.cilium.image.tag }}
{{- end }}
{{- if .Values.components.cilium.image.pullPolicy }}
pullPolicy: {{ .Values.components.cilium.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium API Server.
*/}}
{{- define "cilium.apiserver.image" -}}
{{- if (and .Values.components.cilium.apiserver.image.registry .Values.components.cilium.apiserver.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.apiserver.image.registry .Values.components.cilium.apiserver.image.repository }}
{{- else if .Values.components.cilium.apiserver.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.apiserver.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium API Server ETCD.
*/}}
{{- define "cilium.apiserver.etcd.image" -}}
{{- if (and .Values.components.cilium.apiserver.etcd.image.registry .Values.components.cilium.apiserver.etcd.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.apiserver.etcd.image.registry .Values.components.cilium.apiserver.etcd.image.repository }}
{{- else if .Values.components.cilium.apiserver.etcd.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.apiserver.etcd.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium Certgen.
*/}}
{{- define "cilium.certgen.image" -}}
{{- if (and .Values.components.cilium.certgen.image.registry .Values.components.cilium.certgen.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.certgen.image.registry .Values.components.cilium.certgen.image.repository }}
{{- else if .Values.components.cilium.certgen.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.certgen.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium ETCD.
*/}}
{{- define "cilium.etcd.image" -}}
{{- if (and .Values.components.cilium.etcd.image.registry .Values.components.cilium.etcd.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.etcd.image.registry .Values.components.cilium.etcd.image.repository }}
{{- else if .Values.components.cilium.etcd.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.etcd.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium Hubble Relay.
*/}}
{{- define "cilium.hubble.relay.image" -}}
{{- if (and .Values.components.cilium.hubble.relay.image.registry .Values.components.cilium.hubble.relay.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.hubble.relay.image.registry .Values.components.cilium.hubble.relay.image.repository }}
{{- else if .Values.components.cilium.hubble.relay.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.hubble.relay.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium Hubble UI Backend.
*/}}
{{- define "cilium.hubble.ui.backend.image" -}}
{{- if (and .Values.components.cilium.hubble.ui.backend.image.registry .Values.components.cilium.hubble.ui.backend.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.hubble.ui.backend.image.registry .Values.components.cilium.hubble.ui.backend.image.repository }}
{{- else if .Values.components.cilium.hubble.ui.backend.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.hubble.ui.backend.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium Hubble UI Frontend.
*/}}
{{- define "cilium.hubble.ui.frontend.image" -}}
{{- if (and .Values.components.cilium.hubble.ui.frontend.image.registry .Values.components.cilium.hubble.ui.frontend.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.hubble.ui.frontend.image.registry .Values.components.cilium.hubble.ui.frontend.image.repository }}
{{- else if .Values.components.cilium.hubble.ui.frontend.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.hubble.ui.frontend.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium NodeInit.
*/}}
{{- define "cilium.nodeinit.image" -}}
{{- if (and .Values.components.cilium.nodeinit.image.registry .Values.components.cilium.nodeinit.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.nodeinit.image.registry .Values.components.cilium.nodeinit.image.repository }}
{{- else if .Values.components.cilium.nodeinit.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.nodeinit.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium Operator.
*/}}
{{- define "cilium.operator.image" -}}
{{- if (and .Values.components.cilium.operator.image.registry .Values.components.cilium.operator.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.operator.image.registry .Values.components.cilium.operator.image.repository }}
{{- else if .Values.components.cilium.operator.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.operator.image.repository }}
{{- end }}
{{- end }}

{{/*
The image section for Cilium PreFlight.
*/}}
{{- define "cilium.preflight.image" -}}
{{- if (and .Values.components.cilium.preflight.image.registry .Values.components.cilium.preflight.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.cilium.preflight.image.registry .Values.components.cilium.preflight.image.repository }}
{{- else if .Values.components.cilium.preflight.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.cilium.preflight.image.repository }}
{{- end }}
{{- end }}
