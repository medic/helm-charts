{{- define "cht-chart-4x.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cht-chart-4x.fullname" -}}
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

{{- define "cht-chart-4x.gcp.labels" -}}
app.kubernetes.io/name: {{ include "cht-chart-4x.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
platform: gcp
{{- end }}

{{- define "cht-chart-4x.gcp.ingressClass" -}}
gce
{{- end }}
