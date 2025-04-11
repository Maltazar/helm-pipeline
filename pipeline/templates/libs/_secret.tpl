{{- define "libs.secret.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.secrets }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: Secret
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
type: {{ $val.type | default "Opaque" }}
data:
{{- if $val.data }}
{{ toYaml $val.data | indent 2 }}
{{- end }}
stringData:
{{- if $val.stringData }}
{{ toYaml $val.stringData | indent 2 }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.secret" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "secret" ) -}}
{{- end -}}

{{- define "libs.secret.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "secret" ) -}}
{{- end -}} 