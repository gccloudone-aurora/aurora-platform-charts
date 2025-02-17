{{- define "alertmanager.channel.receivers" -}}
{{- range $severity, $sVal := .Values.components.prometheus.alertmanager.config.severities }}
{{- range $environment, $matchers := $.Values.components.prometheus.alertmanager.config.environments }}
{{- $envSeverityPair := printf "%s%s" $environment (camelcase $severity) }}
- name: aurora_{{ $environment }}_{{ $severity }}
  webhook_configs:
    - url: "http://prometheus-msteams:2000/{{ $envSeverityPair }}"
      send_resolved: true
- name: aurora_{{ $environment }}_{{ $severity }}_no_resolve
  webhook_configs:
    - url: "http://prometheus-msteams:2000/{{ $envSeverityPair }}"
      send_resolved: false
{{- end }}
{{- end }}
{{- end }}

{{- define "alertmanager.channel.routes" -}}
{{- $severity := index . 0 -}}
{{- $matcher := index . 1 -}}
{{- $environment := index . 2 -}}
- matchers: [{{ $matcher }}]
  receiver: aurora_{{ $environment }}_{{ $severity }}
  routes:
    - matchers: ["resolves = never"]
      receiver: aurora_{{ $environment }}_{{ $severity }}_no_resolve
{{- end }}

{{- define "alertmanager.email.receivers" -}}
{{- range $name, $config := .Values.components.prometheus.alertmanager.config.smtp.sendAddresses }}
- name: {{ $name }}
  email_configs:
    - to: {{ $config.to }}
      send_resolved: true
      html: '{{`{{ template "email.email.html" . }}`}}'
- name: {{ $name }}_no_resolve
  email_configs:
    - to: {{ $config.to }}
      send_resolved: false
      html: '{{`{{ template "email.email.html" . }}`}}'
{{- end }}
{{- end }}

{{- define "alertmanager.email.routes" -}}
{{- range $name, $config := .Values.components.prometheus.alertmanager.config.smtp.sendAddresses }}
- matchers: [{{ $config.matchers }}]
  receiver: {{ $name }}
  continue: true
  routes:
    - matchers: ["resolves = never"]
      receiver: {{ $name }}_no_resolve
      continue: true
{{- end }}
{{- end }}

{{- define "alertmanager.jiraAlert.receivers" -}}
{{- range $severity, $sVal := .Values.components.prometheus.jiralert.receivers }}
- name: jiralert_{{ $severity }}
  webhook_configs:
    - url: 'http://prometheus-jiralert:9097/alert'
{{- end }}
{{- end }}


{{- define "alertmanager.jiraAlert.routes" -}}
{{- $severity := index . 0 -}}
- receiver: jiralert_{{ $severity }}
  continue: true
{{- end }}



{{/*
The Alertmanager configuration.
*/}}
{{- define "alertmanager.config" -}}
global:
  resolve_timeout: 6m
  smtp_smarthost: {{ .Values.components.prometheus.alertmanager.config.smtp.smarthost }}
  smtp_from: {{ .Values.components.prometheus.alertmanager.config.smtp.from }}
  smtp_auth_username: {{ .Values.components.prometheus.alertmanager.config.smtp.auth_username }}
  smtp_auth_password: {{ .Values.components.prometheus.alertmanager.config.smtp.auth_password }}
  smtp_require_tls: true

receivers:
  - name: black_hole #Empty default receiver
  {{- include "alertmanager.channel.receivers" . | indent 2 }}
  {{- include "alertmanager.email.receivers" . | indent 2 }}
  {{- include "alertmanager.jiraAlert.receivers" . | indent 2 }}
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
        {{- include "alertmanager.email.routes" . | indent 8 }}
        {{- range $severity, $severityValue := .Values.components.prometheus.alertmanager.config.severities }}
        - matchers: ["severity = {{ $severityValue }}"]
          routes:
          {{- if hasKey $.Values.components.prometheus.jiralert.receivers $severity }}
{{ include "alertmanager.jiraAlert.routes" (list $severity)  | indent 12 }}
          {{- end }}
          {{- range $environment, $envRoute := $.Values.components.prometheus.alertmanager.config.environments }}
          {{- range $matcher := $envRoute.matchers }}
{{ include "alertmanager.channel.routes" (list $severity $matcher $environment .) | indent 12 }}
        {{- end }}
        {{- end }}
        {{- end }}

    ### CLUSTER-WIDE ALERTS
    - matchers: ["scope = cluster"]
      receiver: black_hole
      routes:
        {{- include "alertmanager.email.routes" . | indent 8 }}
        {{- range $severity, $severityValue := .Values.components.prometheus.alertmanager.config.severities }}
        - matchers: ["severity = {{ $severityValue }}"]
          routes:
          {{- if hasKey $.Values.components.prometheus.jiralert.receivers $severity }}
{{ include "alertmanager.jiraAlert.routes" (list $severity)  | indent 12 }}
          {{- end }}
          {{- range $environment, $envRoute := $.Values.components.prometheus.alertmanager.config.environments }}
          {{- range $matcher := $envRoute.matchers }}
{{ include "alertmanager.channel.routes" (list $severity $matcher $environment .) | indent 12 }}
        {{- end }}
        {{- end }}
        {{- end }}

    ### NAMESPACE-SPECIFIC ALERTS
    - matchers: ["scope = namespace", "namespace =~ (.*-system|gitlab|gitlab-runner-build-dev|gitlab-runner-build-prod|gitlab-runner-infra|jfrog|loki|trivy|vault)"]
      receiver: black_hole
      routes:
        {{- include "alertmanager.email.routes" . | indent 8 }}
        {{- range $severity, $severityValue := .Values.components.prometheus.alertmanager.config.severities }}
        - matchers: ["severity = {{ $severityValue }}"]
          routes:
          {{- if hasKey $.Values.components.prometheus.jiralert.receivers $severity }}
{{ include "alertmanager.jiraAlert.routes" (list $severity)  | indent 12 }}
          {{- end }}
          {{- range $environment, $envRoute := $.Values.components.prometheus.alertmanager.config.environments }}
          {{- range $matcher := $envRoute.matchers }}
{{ include "alertmanager.channel.routes" (list $severity $matcher $environment .) | indent 12 }}
        {{- end }}
        {{- end }}
        {{- end }}

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

templates:
  - '/etc/alertmanager/config/*.tmpl'
  - '/etc/alertmanager/config/*.html'
{{- end }}
