{{- define "libs.configmap.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.configmaps }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: ConfigMap
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
data:
{{- if $val.data }}
{{ toYaml $val.data | indent 2 }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.configmap" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "configmap" ) -}}
{{- end -}}

{{- define "libs.configmap.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "configmap" ) -}}
{{- end -}} 