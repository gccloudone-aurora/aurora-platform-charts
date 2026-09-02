{{/*
Define order in this file:
  1. alertmanager.channel.receivers
  2. alertmanager.channel.routes
  3. alertmanager.notification.routes
  4. alertmanager.config
*/}}

{{- define "alertmanager.channel.receivers" -}}
{{- $webhooks := .Values.components.prometheus.msteams.webhooks | default dict }}
{{- range $severity, $sVal := .Values.components.prometheus.alertmanager.config.severities }}
{{- range $environment, $matchers := $.Values.components.prometheus.alertmanager.config.environments }}
{{- $envSeverityPair := printf "%s%s" $environment (camelcase $severity) }}
{{- with $webhookURL := get $webhooks $envSeverityPair }}
- name: aurora_{{ $environment }}_{{ $severity }}
  msteamsv2_configs:
    - webhook_url: {{ $webhookURL | quote }}
      send_resolved: true
      title: '{{`{{ template "teams.v2.title" . }}`}}'
      text: '{{`{{ template "teams.v2.text" . }}`}}'
- name: aurora_{{ $environment }}_{{ $severity }}_no_resolve
  msteamsv2_configs:
    - webhook_url: {{ $webhookURL | quote }}
      send_resolved: false
      title: '{{`{{ template "teams.v2.title" . }}`}}'
      text: '{{`{{ template "teams.v2.text" . }}`}}'

{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "alertmanager.channel.routes" -}}
{{- $severity := index . 0 -}}
{{- $matcher := index . 1 -}}
{{- $environment := index . 2 -}}
- matchers: [{{ $matcher }}, "teams_version = v2"]
  receiver: aurora_{{ $environment }}_{{ $severity }}
  routes:
    - matchers: ["alertname =~ Trivy.*Vulnerabilities.*"]
      receiver: aurora_{{ $environment }}_{{ $severity }}_no_resolve
      repeat_interval: 24h
    - matchers: ["resolves = never"]
      receiver: aurora_{{ $environment }}_{{ $severity }}_no_resolve
{{- end }}

{{/*
Shared child routes under each parent alert scope (node-clock, cluster, namespace).

Produces a list shaped like:

  # then one block per configured MS Teams severity × environment matcher.
  # Alerts opt in to MS Teams delivery with the teams_version="v2" label.
  - matchers: ["severity = <P1-Critical|...>"]
    routes:
      - matchers: [<environment matcher>, "teams_version = v2"]
        receiver: aurora_<env>_<severity>
        routes:
          - matchers: ["alertname =~ Trivy.*Vulnerabilities.*"]
            receiver: aurora_<env>_<severity>_no_resolve
            repeat_interval: 24h
          - matchers: ["resolves = never"]
            receiver: aurora_<env>_<severity>_no_resolve
*/}}
{{- define "alertmanager.notification.routes" -}}
{{- $webhooks := .Values.components.prometheus.msteams.webhooks | default dict }}
{{- range $severity, $severityValue := .Values.components.prometheus.alertmanager.config.severities }}
{{- $hasChannelRoute := false }}
{{- range $environment, $envRoute := $.Values.components.prometheus.alertmanager.config.environments }}
{{- $envSeverityPair := printf "%s%s" $environment (camelcase $severity) }}
{{- if and (get $webhooks $envSeverityPair) $envRoute.matchers }}
{{- $hasChannelRoute = true }}
{{- end }}
{{- end }}
{{- if $hasChannelRoute }}
- matchers: ["severity = {{ $severityValue }}"]
  routes:
  {{- range $environment, $envRoute := $.Values.components.prometheus.alertmanager.config.environments }}
  {{- $envSeverityPair := printf "%s%s" $environment (camelcase $severity) }}
  {{- if get $webhooks $envSeverityPair }}
  {{- range $matcher := $envRoute.matchers }}
  {{- include "alertmanager.channel.routes" (list $severity $matcher $environment) | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
The Alertmanager configuration.
*/}}
{{- define "alertmanager.config" -}}
global:
  resolve_timeout: 6m

receivers:
  - name: black_hole #Empty default receiver
  {{- include "alertmanager.channel.receivers" . | indent 2 }}
  {{- with .Values.components.prometheus.alertmanager.config.deadMansSwitchURL }}
  - name: dms
    webhook_configs:
      - url: {{ . | quote }}
        send_resolved: false
  {{- end }}
  {{- with .Values.components.prometheus.alertmanager.config.additionalConfig.receivers }}
  {{ toYaml . | indent 2 }}
  {{- end }}

route:
  group_by: ['cluster', 'alertname', 'namespace', 'class', 'target', 'label_agentpool']
  group_interval: 10m
  group_wait: 2m
  # repeat_interval cannot be greater than alertmanagerSpec retention
  repeat_interval: 1w
  receiver: black_hole

  routes:
    {{- if .Values.components.prometheus.alertmanager.config.deadMansSwitchURL }}
    - matchers: ["alertname = Watchdog"]
      group_interval: 1s
      repeat_interval: 1m
      receiver: dms
    {{- end }}
    {{- with .Values.components.prometheus.alertmanager.config.additionalConfig.routes }}
    {{ toYaml . | indent 4 }}
    {{- end }}

    ### Override to reduce noise from node clock alerts, see CN-3357
    - matchers: ["alertname =~ NodeClockNotSynchronising|NodeClockSkewDetected"]
      receiver: black_hole
      group_interval: 1d
      group_by: ['cluster', 'alertname']
      routes:
        {{- include "alertmanager.notification.routes" . | nindent 8 }}

    ### CLUSTER-WIDE ALERTS
    - matchers: ["scope = cluster"]
      receiver: black_hole
      routes:
        {{- include "alertmanager.notification.routes" . | nindent 8 }}

    ### NAMESPACE-SPECIFIC ALERTS
    - matchers: ["scope = namespace", "namespace =~ (.*-system|gitlab|gitlab-runner-build-dev|gitlab-runner-build-prod|gitlab-runner-infra|jfrog|loki|trivy|vault)"]
      receiver: black_hole
      routes:
        {{- include "alertmanager.notification.routes" . | nindent 8 }}

inhibit_rules:
  # Don't alert generic NodeNotReady when there is a known cause
  - target_matchers: [alertname="NodeNotReady"]
    source_matchers: [alertname=~"(NodeDiskPressure|NodeMemoryPressure|NodePIDPressure|NodeNetworkUnavailable)"]
    equal: ['cluster', 'node']
  - target_matchers: [alertname="NodeDiskFull"]
    source_matchers: [alertname=~"NodeDiskPressure"]
    equal: ['cluster', 'node']
  - target_matchers: [alertname="NodeNotReady"]
    source_matchers: [alertname="NodeReadinessFlapping"]
    equal: ['cluster', 'node']
  - target_matchers: [alertname="NodeLowPodCapacity"]
    source_matchers: [alertname="NodePodsFull"]
    equal: ['cluster', 'node']
  - target_matchers: [alertname="NodepoolReachingPodCapacity"]
    source_matchers: [alertname="NodepoolPodsFull"]
    equal: ['cluster', 'label_agentpool']
  - target_matchers: [alertname="TotalNodepoolReachingPodCapacity"]
    source_matchers: [alertname="TotalNodepoolPodsFull"]
    equal: ['cluster', 'total_nodepool']
  - target_matchers: [alertname="VeleroBackupFailure"]
    source_matchers: [alertname=~"(ContinuousVeleroBackupFailure|VeleroHourlyBackupFailure)"]
    equal: ['cluster', 'schedule']
  - target_matchers: [alertname="VeleroBackupPartialFailure"]
    source_matchers: [alertname=~"(ContinuousVeleroBackupPartialFailure|VeleroHourlyBackupPartialFailure)"]
    equal: ['cluster', 'schedule']
  - target_matchers: [alertname="JobFailed"]
    source_matchers: [alertname="BackupJobFailed"]
    equal: ['cluster', 'job_name']
  - target_matchers: [alertname="PodNotReady"]
    source_matchers: [alertname=~"(ContainerWaiting|ContainerImagePullProblem)"]
    equal: ['cluster', 'namespace', 'pod']
  - target_matchers: [alertname="PVCStorageRemainingLow"]
    source_matchers: [alertname="PrometheusStorageLow"]
    equal: ['cluster', 'namespace', 'persistentvolumeclaim']
  - target_matchers: [alertname="PVCStorageRemainingLow"]
    source_matchers: [alertname="PVCStorageRemainingNone"]
    equal: ['cluster', 'namespace', 'persistentvolumeclaim']
  # When an alert has a minor and major version with the same name, the major inhibits the minor
  - target_matchers: [severity="P3-Minor"]
    source_matchers: [severity="P2-Major"]
    equal: ['cluster', 'namespace', 'alertname']
  - target_matchers: [alertname="ManyContainerRestarts"]
    source_matchers: [alertname="ContainerCrashLooping"]
    equal: ['cluster', 'namespace', 'pod', 'container']
  - target_matchers: [alertname="GatekeeperMetricsUnavailable"]
    source_matchers: [alertname=~"(ContainerCrashLooping|ContainerWaiting|ContainerImagePullProblem|ManyContainerRestarts|PodNotReady)", namespace="gatekeeper-system"]
    equal: ['cluster']

templates:
  - '/etc/alertmanager/config/*.tmpl'
{{- end }}
