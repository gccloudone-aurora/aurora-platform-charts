{{/*
The image section for Istio.
*/}}
{{- define "ingressIstioController.image" -}}
{{- if (and .Values.components.istio.ingressIstioController.image.registry .Values.components.istio.ingressIstioController.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.istio.ingressIstioController.image.registry .Values.components.istio.ingressIstioController.image.repository }}
{{- else if .Values.components.istio.ingressIstioController.image.repository }}
repository: {{ printf "%s/%s" (default "ghcr.io" .Values.global.container.registry) .Values.components.istio.ingressIstioController.image.repository }}
{{- end }}
{{- if .Values.components.istio.ingressIstioController.image.tag }}
tag: {{ .Values.components.istio.ingressIstioController.image.tag }}
{{- end }}
{{- if .Values.components.istio.ingressIstioController.image.pullPolicy }}
pullPolicy: {{ .Values.components.istio.ingressIstioController.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for istiod.
*/}}
{{- define "istiod.image" -}}
{{- if (and .Values.components.istio.istiod.image.registry .Values.components.istio.istiod.image.repository) }}
hub: {{ printf "%s/%s" .Values.components.istio.istiod.image.registry .Values.components.istio.istiod.image.repository }}
{{- else if .Values.components.istio.istiod.image.repository }}
hub: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.istio.istiod.image.repository }}
{{- end }}
{{- if .Values.components.istio.istiod.image.tag }}
tag: {{ .Values.components.istio.istiod.image.tag }}
{{- end }}
{{- if .Values.components.istio.istiod.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.istio.istiod.image.pullPolicy }}
{{- end }}
{{- if .Values.components.istio.imagePullSecrets }}
imagePullSecrets: {{ .Values.components.istio.imagePullSecrets }}
{{- end }}
{{- if .Values.components.istio.istiod.image.variant }}
variant: {{ .Values.components.istio.istiod.image.variant }}
{{- end }}
{{- end }}

{{/*
The image section for istiod pilot.
*/}}
{{- define "istiod.pilot.image" -}}
{{- if (and .Values.components.istio.istiod.pilot.image.registry .Values.components.istio.istiod.pilot.image.repository) }}
hub: {{ printf "%s/%s" .Values.components.istio.istiod.pilot.image.registry .Values.components.istio.istiod.pilot.image.repository }}
{{- else if .Values.components.istio.istiod.pilot.image.repository }}
hub: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.istio.istiod.pilot.image.repository }}
{{- end }}
{{- if .Values.components.istio.istiod.pilot.image.tag }}
tag: {{ .Values.components.istio.istiod.pilot.image.tag }}
{{- end }}
{{- if .Values.components.istio.istiod.pilot.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.istio.istiod.pilot.image.pullPolicy }}
{{- end }}
{{- if .Values.components.istio.imagePullSecrets }}
imagePullSecrets: {{ .Values.components.istio.imagePullSecrets }}
{{- end }}
{{- if .Values.components.istio.istiod.pilot.image.variant }}
variant: {{ .Values.components.istio.istiod.pilot.image.variant }}
{{- end }}
{{- end }}

{{/*
The image section for istiod proxy.
*/}}
{{- define "istiod.proxy.image" -}}
{{- if (and .Values.components.istio.istiod.proxy.image.registry .Values.components.istio.istiod.proxy.image.repository) }}
hub: {{ printf "%s/%s" .Values.components.istio.istiod.proxy.image.registry .Values.components.istio.istiod.proxy.image.repository }}
{{- else if .Values.components.istio.istiod.proxy.image.repository }}
hub: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.istio.istiod.proxy.image.repository }}
{{- end }}
{{- if .Values.components.istio.istiod.proxy.image.tag }}
tag: {{ .Values.components.istio.istiod.proxy.image.tag }}
{{- end }}
{{- if .Values.components.istio.istiod.proxy.image.pullPolicy }}
imagePullPolicy: {{ .Values.components.istio.istiod.proxy.image.pullPolicy }}
{{- end }}
{{- if .Values.components.istio.imagePullSecrets }}
imagePullSecrets: {{ .Values.components.istio.imagePullSecrets }}
{{- end }}
{{- if .Values.components.istio.istiod.proxy.image.variant }}
variant: {{ .Values.components.istio.istiod.proxy.image.variant }}
{{- end }}
{{- end }}
