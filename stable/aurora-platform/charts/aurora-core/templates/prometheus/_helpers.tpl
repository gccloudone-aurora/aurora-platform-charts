{{/*
The image section for Prometheus Operator.
*/}}
{{- define "prometheus.operator.image" -}}
{{- if .Values.components.prometheus.operator.image.registry }}
registry: {{ .Values.components.prometheus.operator.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.operator.image.repository }}
repository: {{ .Values.components.prometheus.operator.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.operator.image.tag }}
tag: {{ .Values.components.prometheus.operator.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.operator.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.operator.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus Operator Admission Webhooks.
*/}}
{{- define "prometheus.operator.admissionWebhooks.image" -}}
{{- if .Values.components.prometheus.operator.admissionWebhooks.image.registry }}
registry: {{ .Values.components.prometheus.operator.admissionWebhooks.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.operator.admissionWebhooks.image.repository }}
repository: {{ .Values.components.prometheus.operator.admissionWebhooks.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.operator.admissionWebhooks.image.tag }}
tag: {{ .Values.components.prometheus.operator.admissionWebhooks.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.operator.admissionWebhooks.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.operator.admissionWebhooks.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus Operator Config Reloader.
*/}}
{{- define "prometheus.operator.prometheusConfigReloader.image" -}}
{{- if .Values.components.prometheus.operator.prometheusConfigReloader.image.registry }}
registry: {{ .Values.components.prometheus.operator.prometheusConfigReloader.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.operator.prometheusConfigReloader.image.repository }}
repository: {{ .Values.components.prometheus.operator.prometheusConfigReloader.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.operator.prometheusConfigReloader.image.tag }}
tag: {{ .Values.components.prometheus.operator.prometheusConfigReloader.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.operator.prometheusConfigReloader.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.operator.prometheusConfigReloader.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus Operator Thanos.
*/}}
{{- define "prometheus.operator.thanos.image" -}}
{{- if .Values.components.prometheus.operator.thanos.image.registry }}
registry: {{ .Values.components.prometheus.operator.thanos.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.operator.thanos.image.repository }}
repository: {{ .Values.components.prometheus.operator.thanos.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.operator.thanos.image.tag }}
tag: {{ .Values.components.prometheus.operator.thanos.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.operator.thanos.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.operator.thanos.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for AlertManagerSpec.
*/}}
{{- define "prometheus.alertmanager.alertmanagerSpec.image" -}}
{{- if .Values.components.prometheus.alertmanager.alertmanagerSpec.image.registry }}
registry: {{ .Values.components.prometheus.alertmanager.alertmanagerSpec.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.alertmanager.alertmanagerSpec.image.repository }}
repository: {{ .Values.components.prometheus.alertmanager.alertmanagerSpec.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.alertmanager.alertmanagerSpec.image.tag }}
tag: {{ .Values.components.prometheus.alertmanager.alertmanagerSpec.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.alertmanager.alertmanagerSpec.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.alertmanager.alertmanagerSpec.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for PrometheusSpec.
*/}}
{{- define "prometheus.prometheus.prometheusSpec.image" -}}
{{- if .Values.components.prometheus.prometheus.prometheusSpec.image.registry }}
registry: {{ .Values.components.prometheus.prometheus.prometheusSpec.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.prometheus.prometheusSpec.image.repository }}
repository: {{ .Values.components.prometheus.prometheus.prometheusSpec.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.prometheus.prometheusSpec.image.tag }}
tag: {{ .Values.components.prometheus.prometheus.prometheusSpec.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.prometheus.prometheusSpec.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.prometheus.prometheusSpec.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for ThanosRulerSpec.
*/}}
{{- define "prometheus.thanosRuler.thanosRulerSpec.image" -}}
{{- if .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.registry }}
registry: {{ .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.registry  }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.repository }}
repository: {{ .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.tag }}
tag: {{ .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.thanosRuler.thanosRulerSpec.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Grafana.
*/}}
{{- define "prometheus.grafana.image" -}}
{{- if (and .Values.components.prometheus.grafana.image.registry .Values.components.prometheus.grafana.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.grafana.image.registry .Values.components.prometheus.grafana.image.repository }}
{{- else if .Values.components.prometheus.grafana.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.prometheus.grafana.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.grafana.image.tag }}
tag: {{ .Values.components.prometheus.grafana.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.grafana.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.grafana.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Grafana Dashboards.
*/}}
{{- define "prometheus.grafana.downloadDashboards.image" -}}
{{- if (and .Values.components.prometheus.grafana.downloadDashboards.image.registry .Values.components.prometheus.grafana.downloadDashboards.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.grafana.downloadDashboards.image.registry .Values.components.prometheus.grafana.downloadDashboards.image.repository }}
{{- else if .Values.components.prometheus.grafana.downloadDashboards.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.prometheus.grafana.downloadDashboards.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.grafana.downloadDashboards.image.tag }}
tag: {{ .Values.components.prometheus.grafana.downloadDashboards.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.grafana.downloadDashboards.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.grafana.downloadDashboards.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Grafana initChownData.
*/}}
{{- define "prometheus.grafana.initChownData.image" -}}
{{- if (and .Values.components.prometheus.grafana.initChownData.image.registry .Values.components.prometheus.grafana.initChownData.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.grafana.initChownData.image.registry .Values.components.prometheus.grafana.initChownData.image.repository }}
{{- else if .Values.components.prometheus.grafana.initChownData.image.repository }}
repository: {{ printf "%s/%s" (default "docker.io" .Values.global.container.registry) .Values.components.prometheus.grafana.initChownData.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.grafana.initChownData.image.tag }}
tag: {{ .Values.components.prometheus.grafana.initChownData.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.grafana.initChownData.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.grafana.initChownData.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Grafana Sidecar.
*/}}
{{- define "prometheus.grafana.sidecar.image" -}}
{{- if (and .Values.components.prometheus.grafana.sidecar.image.registry .Values.components.prometheus.grafana.sidecar.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.grafana.sidecar.image.registry .Values.components.prometheus.grafana.sidecar.image.repository }}
{{- else if .Values.components.prometheus.grafana.sidecar.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.prometheus.grafana.sidecar.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.grafana.sidecar.image.tag }}
tag: {{ .Values.components.prometheus.grafana.sidecar.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.grafana.sidecar.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.grafana.sidecar.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Kube State Metrics.
*/}}
{{- define "prometheus.kubeStateMetrics.image" -}}
{{- if (and .Values.components.prometheus.kubeStateMetrics.image.registry .Values.components.prometheus.kubeStateMetrics.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.kubeStateMetrics.image.registry .Values.components.prometheus.kubeStateMetrics.image.repository }}
{{- else if .Values.components.prometheus.kubeStateMetrics.image.repository }}
repository: {{ printf "%s/%s" (default "registry.k8s.io" .Values.global.container.registry) .Values.components.prometheus.kubeStateMetrics.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.kubeStateMetrics.image.tag }}
tag: {{ .Values.components.prometheus.kubeStateMetrics.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.kubeStateMetrics.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.kubeStateMetrics.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus Node Exporter.
*/}}
{{- define "prometheus.prometheusNodeExporter.image" -}}
{{- if (and .Values.components.prometheus.prometheusNodeExporter.image.registry .Values.components.prometheus.prometheusNodeExporter.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.prometheusNodeExporter.image.registry .Values.components.prometheus.prometheusNodeExporter.image.repository }}
{{- else if .Values.components.prometheus.prometheusNodeExporter.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.prometheus.prometheusNodeExporter.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.prometheusNodeExporter.image.tag }}
tag: {{ .Values.components.prometheus.prometheusNodeExporter.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.prometheusNodeExporter.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.prometheusNodeExporter.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus Blockbox Exporter.
*/}}
{{- define "prometheus.blackboxExporter.image" -}}
{{- if (and .Values.components.prometheus.blackboxExporter.image.registry .Values.components.prometheus.blackboxExporter.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.blackboxExporter.image.registry .Values.components.prometheus.blackboxExporter.image.repository }}
{{- else if .Values.components.prometheus.blackboxExporter.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.prometheus.blackboxExporter.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.blackboxExporter.image.tag }}
tag: {{ .Values.components.prometheus.blackboxExporter.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.blackboxExporter.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.blackboxExporter.image.pullPolicy }}
{{- end }}
{{- if .Values.components.prometheus.blackboxExporter.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml .Values.components.prometheus.blackboxExporter.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The image section for Prometheus MSTeams.
*/}}
{{- define "prometheus.msteams.image" -}}
{{- if (and .Values.components.prometheus.msteams.image.registry .Values.components.prometheus.msteams.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.msteams.image.registry .Values.components.prometheus.msteams.image.repository }}
{{- else if .Values.components.prometheus.msteams.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.prometheus.msteams.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.msteams.image.tag }}
tag: {{ .Values.components.prometheus.msteams.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.msteams.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.msteams.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for Jira Alert.
*/}}
{{- define "prometheus.jiralert.image" -}}
{{- if (and .Values.components.prometheus.jiralert.image.registry .Values.components.prometheus.jiralert.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.prometheus.jiralert.image.registry .Values.components.prometheus.jiralert.image.repository }}
{{- else if .Values.components.prometheus.jiralert.image.repository }}
repository: {{ printf "%s/%s" (default "quay.io" .Values.global.container.registry) .Values.components.prometheus.jiralert.image.repository }}
{{- end }}
{{- if .Values.components.prometheus.jiralert.image.tag }}
tag: {{ .Values.components.prometheus.jiralert.image.tag }}
{{- end }}
{{- if .Values.components.prometheus.jiralert.image.pullPolicy }}
pullPolicy: {{ .Values.components.prometheus.jiralert.image.pullPolicy }}
{{- end }}
{{- end }}
