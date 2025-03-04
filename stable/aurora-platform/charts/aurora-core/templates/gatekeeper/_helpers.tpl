{{/*
The image section for gatekeeper.
*/}}
{{- define "gatekeeper.image" -}}
{{- if (and .Values.components.gatekeeper.image.registry .Values.components.gatekeeper.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.gatekeeper.image.registry .Values.components.gatekeeper.image.repository }}
{{- else if .Values.components.gatekeeper.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.image.repository }}
{{- end }}
{{- if (and .Values.components.gatekeeper.image.registry .Values.components.gatekeeper.image.crdRepository) }}
crdRepository: {{ printf "%s/%s" .Values.components.gatekeeper.image.registry .Values.components.gatekeeper.image.crdRepository }}
{{- else if .Values.components.gatekeeper.image.crdRepository }}
crdRepository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.image.crdRepository }}
{{- end }}
{{- if .Values.components.gatekeeper.image.tag }}
tag: {{ .Values.components.gatekeeper.image.tag }}
{{- end }}
{{- if .Values.components.gatekeeper.image.pullPolicy }}
pullPolicy: {{ .Values.components.gatekeeper.image.pullPolicy }}
{{- end }}
{{- if .Values.components.gatekeeper.imagePullSecrets }}
pullSecrets:
  {{- toYaml .Values.components.gatekeeper.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The image section for gatekeeper postInstall.
*/}}
{{- define "gatekeeper.postInstall.image" -}}
{{- if (and .Values.components.gatekeeper.postInstall.image.registry .Values.components.gatekeeper.postInstall.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.gatekeeper.postInstall.image.registry .Values.components.gatekeeper.postInstall.image.repository }}
{{- else if .Values.components.gatekeeper.postInstall.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.postInstall.image.repository }}
{{- end }}
{{- if .Values.components.gatekeeper.postInstall.image.tag }}
tag: {{ .Values.components.gatekeeper.postInstall.image.tag }}
{{- end }}
{{- if .Values.components.gatekeeper.postInstall.image.pullPolicy }}
pullPolicy: {{ .Values.components.gatekeeper.postInstall.image.pullPolicy }}
{{- end }}
{{- if .Values.components.gatekeeper.imagePullSecrets }}
pullSecrets:
  {{- toYaml .Values.components.gatekeeper.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The image section for gatekeeper postInstall probeWebhook.
*/}}
{{- define "gatekeeper.postInstall.probeWebhook.image" -}}
{{- if (and .Values.components.gatekeeper.postInstall.probeWebhook.image.registry .Values.components.gatekeeper.postInstall.probeWebhook.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.gatekeeper.postInstall.probeWebhook.image.registry .Values.components.gatekeeper.postInstall.probeWebhook.image.repository }}
{{- else if .Values.components.gatekeeper.postInstall.probeWebhook.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.postInstall.probeWebhook.image.repository }}
{{- end }}
{{- if .Values.components.gatekeeper.postInstall.probeWebhook.image.tag }}
tag: {{ .Values.components.gatekeeper.postInstall.probeWebhook.image.tag }}
{{- end }}
{{- if .Values.components.gatekeeper.postInstall.probeWebhook.image.pullPolicy }}
pullPolicy: {{ .Values.components.gatekeeper.postInstall.probeWebhook.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for gatekeeper postUpgrade.
*/}}
{{- define "gatekeeper.postUpgrade.image" -}}
{{- if (and .Values.components.gatekeeper.postUpgrade.image.registry .Values.components.gatekeeper.postUpgrade.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.gatekeeper.postUpgrade.image.registry .Values.components.gatekeeper.postUpgrade.image.repository }}
{{- else if .Values.components.gatekeeper.postUpgrade.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.postUpgrade.image.repository }}
{{- end }}
{{- if .Values.components.gatekeeper.postUpgrade.image.tag }}
tag: {{ .Values.components.gatekeeper.postUpgrade.image.tag }}
{{- end }}
{{- if .Values.components.gatekeeper.postUpgrade.image.pullPolicy }}
pullPolicy: {{ .Values.components.gatekeeper.postUpgrade.image.pullPolicy }}
{{- end }}
{{- if .Values.components.gatekeeper.imagePullSecrets }}
pullSecrets:
  {{- toYaml .Values.components.gatekeeper.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The image section for gatekeeper preUninstall.
*/}}
{{- define "gatekeeper.preUninstall.image" -}}
{{- if (and .Values.components.gatekeeper.preUninstall.image.registry .Values.components.gatekeeper.preUninstall.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.gatekeeper.preUninstall.image.registry .Values.components.gatekeeper.preUninstall.image.repository }}
{{- else if .Values.components.gatekeeper.preUninstall.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.gatekeeper.preUninstall.image.repository }}
{{- end }}
{{- if .Values.components.gatekeeper.preUninstall.image.tag }}
tag: {{ .Values.components.gatekeeper.preUninstall.image.tag }}
{{- end }}
{{- if .Values.components.gatekeeper.preUninstall.image.pullPolicy }}
pullPolicy: {{ .Values.components.gatekeeper.preUninstall.image.pullPolicy }}
{{- end }}
{{- if .Values.components.gatekeeper.imagePullSecrets }}
pullSecrets:
  {{- toYaml .Values.components.gatekeeper.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}
