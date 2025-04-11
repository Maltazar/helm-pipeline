{{/*
Use by this
{{- template "helper.mega.var_dump" $variable }}
*/}}
{{- define "helper.mega.var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail -}}
{{- end -}}

{{/*

*/}}
{{- define "helper.enabled.apps" -}}
  {{- $all := . -}}
  {{- $app := list -}}
  {{- range $key, $value := $all.Values -}}
    {{- $valid := "true" -}}
    {{- range $all.Values.global.noneAppVars -}}
      {{- if eq . $key -}}
        {{- $valid = "false" -}}
      {{- end -}}
    {{- end -}}

    {{- if eq $valid "true" -}}
      {{- if kindIs "map" $value -}}
        {{- if (index $all.Values $key).enabled -}}
          {{- if kindIs "string" $app -}}
          {{- $app = $key -}}
          {{- else -}}
          {{- $app = append $app $key -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{ toJson $app }}
{{- end -}}


{{- define "helper.chart" -}}
{{- $all := index . 0 -}}
{{- printf "%s-%s" $all.Chart.Name $all.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{- define "helper.set.labels" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}
labels:
  helm.sh/chart: {{ include "helper.chart" . }}
  app.kubernetes.io/managed-by: {{ $all.Release.Service }}
{{ include "helper.set.selectors" . | indent 2 }}
{{ if $v.labels }}
{{ toYaml $v.labels | nindent 2 }}
{{ end }}
{{- end -}}


{{- define "helper.set.selectors" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}
app.kubernetes.io/name: {{ include "helper.set.naming" (list $all $app $v "selectors") }}
app.kubernetes.io/instance: {{ $all.Release.Name }}
app: {{ $app }}
{{ if $v.selectors }}
{{ toYaml $v.selectors }}
{{ end }}
{{- end -}}


{{- define "helper.set.annotations" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}
{{- if $v.annotations }}
annotations:
{{ toYaml $v.annotations | indent 2 }}
{{- end }}
{{- end -}}

