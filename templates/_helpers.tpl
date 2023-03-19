{{/*
Expand the name of the chart.
*/}}
{{- define "v2board.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "v2board.fullname" -}}
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
{{- define "v2board.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "v2board.labels" -}}
helm.sh/chart: {{ include "v2board.chart" . }}
{{ include "v2board.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "v2board.selectorLabels" -}}
app.kubernetes.io/name: {{ include "v2board.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "v2board.nfs.pv.fullname" -}}
{{- printf "%s-%s-nfs-pv" .Release.Namespace (include "v2board.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "v2board.nfs.pvc.fullname" -}}
{{- printf "%s-%s-nfs-pvc" .Release.Namespace (include "v2board.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "v2board.mariadb.secret" -}}
    {{- if .Values.mariadb.enabled -}}
        {{- if .Values.mariadb.auth.existingSecret -}}
            {{- printf "%s" .Values.mariadb.auth.existingSecret -}}
        {{- else -}}
            {{- printf "%s-mariadb" (include "v2board.fullname" .) -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.externalDatabase.existingSecret -}}
            {{- printf "%s" .Values.externalDatabase.existingSecret -}}
        {{- else -}}
            {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "v2board.redis.secret" -}}
    {{- if .Values.redis.enabled -}}
        {{- if .Values.redis.auth.existingSecret -}}
            {{- printf "%s" .Values.redis.auth.existingSecret -}}
        {{- else -}}
            {{- printf "%s-redis" (include "v2board.fullname" .) -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.externalRedis.existingSecret -}}
            {{- printf "%s" .Values.externalRedis.existingSecret -}}
        {{- else -}}
            {{- printf "%s-externalredis" (include "common.names.fullname" .) -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "redis.fullname" -}}
{{- printf "%s-redis" (include "v2board.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "redis.name" -}}
{{- printf "%s-redis" (include "v2board.name" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}
