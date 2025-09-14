{{/*
The image section for Cert Manager Controller.
*/}}
{{- define "certManager.image" -}}
{{- if (and .Values.components.certManager.image.registry .Values.components.certManager.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.certManager.image.registry .Values.components.certManager.image.repository }}
{{- else if .Values.components.certManager.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.certManager.image.repository }}
{{- end }}
{{- if .Values.components.certManager.image.tag }}
tag: {{ .Values.components.certManager.image.tag }}
{{- end }}
{{- if .Values.components.certManager.image.pullPolicy }}
pullPolicy: {{ .Values.components.certManager.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cert Manager Webhook.
*/}}
{{- define "certManager.webhook.image" -}}
{{- if (and .Values.components.certManager.webhook.image.registry .Values.components.certManager.webhook.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.certManager.webhook.image.registry .Values.components.certManager.webhook.image.repository }}
{{- else if .Values.components.certManager.webhook.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.certManager.webhook.image.repository }}
{{- end }}
{{- if .Values.components.certManager.webhook.image.tag }}
tag: {{ .Values.components.certManager.webhook.image.tag }}
{{- end }}
{{- if .Values.components.certManager.webhook.image.pullPolicy }}
pullPolicy: {{ .Values.components.certManager.webhook.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cert Manager Cainjector.
*/}}
{{- define "certManager.cainjector.image" -}}
{{- if (and .Values.components.certManager.cainjector.image.registry .Values.components.certManager.cainjector.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.certManager.cainjector.image.registry .Values.components.certManager.cainjector.image.repository }}
{{- else if .Values.components.certManager.cainjector.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.certManager.cainjector.image.repository }}
{{- end }}
{{- if .Values.components.certManager.cainjector.image.tag }}
tag: {{ .Values.components.certManager.cainjector.image.tag }}
{{- end }}
{{- if .Values.components.certManager.cainjector.image.pullPolicy }}
pullPolicy: {{ .Values.components.certManager.cainjector.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cert Manager ACME Solver.
*/}}
{{- define "certManager.acmesolver.image" -}}
{{- if (and .Values.components.certManager.acmesolver.image.registry .Values.components.certManager.acmesolver.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.certManager.acmesolver.image.registry .Values.components.certManager.acmesolver.image.repository }}
{{- else if .Values.components.certManager.acmesolver.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.certManager.acmesolver.image.repository }}
{{- end }}
{{- if .Values.components.certManager.acmesolver.image.tag }}
tag: {{ .Values.components.certManager.acmesolver.image.tag }}
{{- end }}
{{- if .Values.components.certManager.acmesolver.image.pullPolicy }}
pullPolicy: {{ .Values.components.certManager.acmesolver.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cert Manager Startup API Check.
*/}}
{{- define "certManager.startupapicheck.image" -}}
{{- if (and .Values.components.certManager.startupapicheck.image.registry .Values.components.certManager.startupapicheck.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.certManager.startupapicheck.image.registry .Values.components.certManager.startupapicheck.image.repository }}
{{- else if .Values.components.certManager.startupapicheck.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.certManager.startupapicheck.image.repository }}
{{- end }}
{{- if .Values.components.certManager.startupapicheck.image.tag }}
tag: {{ .Values.components.certManager.startupapicheck.image.tag }}
{{- end }}
{{- if .Values.components.certManager.startupapicheck.image.pullPolicy }}
pullPolicy: {{ .Values.components.certManager.startupapicheck.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Cert Manager Startup API Check.
*/}}
{{- define "certManager.issuer.dns01Solver" -}}
{{- if eq .Values.global.provider "azure" }}
cnameStrategy: Follow
azureDNS:
    hostedZoneName: {{ required "certManager.issuers.dns01.azure.zone is required" .Values.components.certManager.issuers.dns01.azure.zone }}
    resourceGroupName: {{ required "certManager.issuers.dns01.azure.resourceGroupName is required" .Values.components.certManager.issuers.dns01.azure.resourceGroupName }}
    subscriptionId: {{ required "certManager.issuers.dns01.azure.subscriptionId is required" .Values.components.certManager.issuers.dns01.azure.subscriptionId }}
{{- else if eq .Values.global.provider "aws" }}
cnameStrategy: Follow
route53: {}
{{- end }}
{{- end }}
