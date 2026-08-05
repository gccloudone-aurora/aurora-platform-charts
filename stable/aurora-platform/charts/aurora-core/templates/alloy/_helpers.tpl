{{/*
The image section for Alloy.
*/}}
{{- define "alloy.image" -}}
{{- if .Values.components.alloy.image.registry }}
registry: {{ .Values.components.alloy.image.registry }}
{{- else if .Values.global.container.registry }}
registry: {{ .Values.global.container.registry }}
{{- end }}
{{- if .Values.components.alloy.image.repository }}
repository: {{ .Values.components.alloy.image.repository }}
{{- end }}
{{- if .Values.components.alloy.image.tag }}
tag: {{ .Values.components.alloy.image.tag }}
{{- end }}
{{- if .Values.components.alloy.image.pullPolicy }}
pullPolicy: {{ .Values.components.alloy.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
Loki Write Endpoint Logic.
Unless overriden, use these values. The MGMT cluster should be the central and use svc.
Spoke clusters should use a regular url and hop to the central logger
*/}}
{{- define "alloy.lokiWriteUrl" -}}
{{- if .Values.components.alloy.config.loki.write.url -}}
{{- .Values.components.alloy.config.loki.write.url -}}
{{- else if .Values.global.clusterHasLoki -}}
http://loki-gateway.loki-system.svc.cluster.local/loki/api/v1/push
{{- else -}}
{{- required "components.alloy.config.loki.write.url is required when global.clusterHasLoki is not true" .Values.components.alloy.config.loki.write.url -}}
{{- end -}}
{{- end }}

{{/*
Alloy configuration that watches Kubernetes Event Objects, then ships them out to the Loki instance using loki.write.
*/}}
{{- define "alloy.config" -}}
loki.source.kubernetes_events "cluster_events" {
    job_name    = "integrations/kubernetes/eventhandler"
    log_format  = "logfmt"
    forward_to  = [loki.write.central.receiver]
}

loki.write "central" {
    endpoint {
        url = {{ required "components.alloy.config.loki.write.url is required" .Values.components.alloy.config.loki.write.url | quote }}

        basic_auth {
            username = {{ required "components.alloy.config.loki.write.username is required" .Values.components.alloy.config.loki.write.username | quote }}
            password = {{ required "components.alloy.config.loki.write.password is required" .Values.components.alloy.config.loki.write.password | quote }}
        }
    }

    external_labels = {
        source = "alloy-kubernetes-events",
        events_cluster = {{ .Values.global.cluster | quote }},
    }
}
{{- end }}