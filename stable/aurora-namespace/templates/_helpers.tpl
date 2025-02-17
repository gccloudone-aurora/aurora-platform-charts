{{/*
Expand the name of the chart.
*/}}
{{- define "aurora-namespace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aurora-namespace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aurora-namespace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aurora-namespace.labels" -}}
helm.sh/chart: {{ include "aurora-namespace.chart" . }}
{{ include "aurora-namespace.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aurora-namespace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aurora-namespace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Creates the value for the ingress.ssc-spc.gc.ca/allowed-hosts annotation on the namespace.
The .Values.policies.allowedHosts value determine which host names are allowed on the Ingress & VirtualService within the namespace.
Refer to https://aurora.gccloudone.ca/en/documentation/security/policies/restrict-hostname/ for more information.
*/}}
{{- define "aurora-namespace.allowedHosts" -}}
{{- $records := list -}}
{{- range .Values.policies.allowedHosts }}
{{- if regexMatch "/" . }}
{{- $records = append $records (printf "{\"host\": \"%s\",\"path\": \"%s\"}" (regexFind "^[^/]*" .) (regexFind "/.*" .)) }}
{{- else }}
{{- $records = append $records (printf "{\"host\": \"%s\",\"path\": \"/\"}" (regexFind "^[^/]*" .)) }}
{{- end }}
{{- end }}
{{- join "," $records }}
{{- end }}

{{/*
Defines the name of the namespace to adhere to required conventions.
*/}}
{{- define "aurora-namespace.namespaceName" -}}
{{- if (and (or (eq .Values.namespace.type "system") (eq .Values.namespace.type "gateway")) (not (hasSuffix "-system" .Release.Name))) }}
{{- fail "namespace name must end with \"-system\" when type is one of [gateway, system]" }}
{{- else }}
{{- .Release.Name }}
{{- end }}
{{- end }}
