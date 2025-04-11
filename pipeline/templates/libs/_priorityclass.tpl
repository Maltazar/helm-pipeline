{{- define "libs.priorityclass.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.priorityclasses }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
value: {{ $val.value }}
{{- if $val.globalDefault }}
globalDefault: {{ $val.globalDefault }}
{{- end }}
{{- if $val.description }}
description: {{ $val.description }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.priorityclass" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "priorityclass" ) -}}
{{- end -}}

{{- define "libs.priorityclass.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "priorityclass" ) -}}
{{- end -}} 