{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name .Values.enviroment | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create service metadataName as used by Kubernetes.
*/}}
{{- define "chart.metadataName.ingress.backend" -}}
{{- printf "%s-ingress-%s" .Values.microservice.deviceprojectservice.name .Values.enviroment -}}
{{- end }}
{{- define "chart.metadataName.ingress.frontend" -}}
{{- printf "%s-ingress-%s" .Values.microservice.webplatform.name .Values.enviroment -}}
{{- end }}
{{- define "chart.metadataName.clusterIssuer.backend" -}}
{{- printf "%s-%s" .Values.issuer.backend.name .Values.enviroment -}}
{{- end }}
{{- define "chart.metadataName.clusterIssuer.frontend" -}}
{{- printf "%s-%s" .Values.issuer.frontend.name .Values.enviroment -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart.labels" -}}
helm.sh/chart: {{ include "chart.chart" . }}
{{ include "chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chart.selectorLabels.backend" -}}
app: {{ include "chart.metadataName.backend" . }}
{{- end }}
{{- define "chart.selectorLabels.frontend" -}}
app: {{ include "chart.metadataName.frontend" . }}
{{- end }}
