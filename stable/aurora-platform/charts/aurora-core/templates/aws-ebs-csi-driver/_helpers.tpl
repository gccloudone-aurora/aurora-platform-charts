{{/*
The image section for awsEbsCsiDriver.
*/}}
{{- define "awsEbsCsiDriver.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.image.registry .Values.components.awsEbsCsiDriver.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.image.registry .Values.components.awsEbsCsiDriver.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.image.pullPolicy }}
{{- end }}
{{- end }}



{{/*
The image section for provisioner.
*/}}
{{- define "awsEbsCsiDriver.provisioner.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.provisioner.image.registry .Values.components.awsEbsCsiDriver.provisioner.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.provisioner.image.registry .Values.components.awsEbsCsiDriver.provisioner.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.provisioner.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.provisioner.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.provisioner.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.provisioner.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.provisioner.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.provisioner.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for attacher.
*/}}
{{- define "awsEbsCsiDriver.attacher.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.attacher.image.registry .Values.components.awsEbsCsiDriver.attacher.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.attacher.image.registry .Values.components.awsEbsCsiDriver.attacher.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.attacher.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.attacher.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.attacher.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.attacher.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.attacher.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.attacher.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for snapshotter.
*/}}
{{- define "awsEbsCsiDriver.snapshotter.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.snapshotter.image.registry .Values.components.awsEbsCsiDriver.snapshotter.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.snapshotter.image.registry .Values.components.awsEbsCsiDriver.snapshotter.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.snapshotter.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.snapshotter.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.snapshotter.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.snapshotter.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.snapshotter.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.snapshotter.image.pullPolicy }}
{{- end }}
{{- end }}


{{/*
The image section for resizer.
*/}}
{{- define "awsEbsCsiDriver.resizer.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.resizer.image.registry .Values.components.awsEbsCsiDriver.resizer.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.resizer.image.registry .Values.components.awsEbsCsiDriver.resizer.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.resizer.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.resizer.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.resizer.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.resizer.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.resizer.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.resizer.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for nodeDriverRegistrar.
*/}}
{{- define "awsEbsCsiDriver.nodeDriverRegistrar.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.registry .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.registry .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.nodeDriverRegistrar.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
The image section for volumemodifier.
*/}}
{{- define "awsEbsCsiDriver.volumemodifier.image" -}}
{{- if (and .Values.components.awsEbsCsiDriver.volumemodifier.image.registry .Values.components.awsEbsCsiDriver.volumemodifier.image.repository) }}
repository: {{ printf "%s/%s" .Values.components.awsEbsCsiDriver.volumemodifier.image.registry .Values.components.awsEbsCsiDriver.volumemodifier.image.repository }}
{{- else if .Values.components.awsEbsCsiDriver.volumemodifier.image.repository }}
repository: {{ printf "%s/%s" (default "public.ecr.aws" .Values.global.container.registry) .Values.components.awsEbsCsiDriver.volumemodifier.image.repository }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.volumemodifier.image.tag }}
tag: {{ .Values.components.awsEbsCsiDriver.volumemodifier.image.tag }}
{{- end }}
{{- if .Values.components.awsEbsCsiDriver.volumemodifier.image.pullPolicy }}
pullPolicy: {{ .Values.components.awsEbsCsiDriver.volumemodifier.image.pullPolicy }}
{{- end }}
{{- end }}

