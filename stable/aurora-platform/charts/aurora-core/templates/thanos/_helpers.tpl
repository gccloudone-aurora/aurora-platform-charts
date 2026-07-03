{{/*
Keep thanos container image as a flat "registry/repository:tag" string

Uses the same `thanos/thanos` image as the base thanos side car in kube prometheus stack. Therefore,
the query-path tag is pinned explicitly in values (components.thanos.image.tag), and
 MUST be kept >= the sidecar's Thanos version.
*/}}
{{- define "thanos.image" -}}
{{- $img := .Values.components.thanos.image -}}
{{- $registry := coalesce $img.registry .Values.global.container.registry "quay.io" -}}
{{- $repository := required "components.thanos.image.repository is required" $img.repository -}}
{{- $tag := required "components.thanos.image.tag is required (pin the Thanos version)" $img.tag -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{/*
Workload-identity client-id annotation for the Store Gateway / Compactor ServiceAccounts.
Reuses the SAME user-assigned managed identity as the Phase 1 sidecar.
*/}}
{{- define "thanos.workloadIdentity.clientId" -}}
{{- if eq .Values.components.thanos.objectStorage.auth "workloadIdentity" -}}
azure.workload.identity/client-id: {{ required "components.thanos.objectStorage.clientId is required when auth=workloadIdentity" .Values.components.thanos.objectStorage.clientId | quote }}
{{- end }}
{{- end -}}
