{{- define "opal.serverName" -}}
{{ printf "%s-server" .Release.Name }}
{{- end -}}

{{- define "opal.clientName" -}}
{{ printf "%s-client" .Release.Name }}
{{- end -}}

{{- define "opal.pgsqlName" -}}
{{ printf "%s-pgsql" .Release.Name }}
{{- end -}}

{{- define "opal.clientSelectorLabels" -}}
app.kubernetes.io/name: {{ include "opal.clientName" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
opal.ac/role: client
{{- end -}}

{{- define "opal.serverSelectorLabels" -}}
app.kubernetes.io/name: {{ include "opal.serverName" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
opal.ac/role: server
{{- end -}}

{{- define "opal.pgsqlSelectorLabels" -}}
app.kubernetes.io/name: {{ include "opal.pgsqlName" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
opal.ac/role: pgsql
{{- end -}}

{{- define "opal.clientLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "opal.clientSelectorLabels" . }}
{{- end -}}

{{- define "opal.serverLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "opal.serverSelectorLabels" . }}
{{- end -}}

{{- define "opal.pgsqlLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "opal.pgsqlSelectorLabels" . }}
{{- end -}}

