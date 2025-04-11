{{- define "libs.limitrange.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.limitranges }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: LimitRange
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  limits:
  {{- range $limit := $val.limits }}
    - type: {{ $limit.type }}
      {{- if $limit.max }}
      max:
{{ toYaml $limit.max | indent 8 }}
      {{- end }}
      {{- if $limit.min }}
      min:
{{ toYaml $limit.min | indent 8 }}
      {{- end }}
      {{- if $limit.default }}
      default:
{{ toYaml $limit.default | indent 8 }}
      {{- end }}
      {{- if $limit.defaultRequest }}
      defaultRequest:
{{ toYaml $limit.defaultRequest | indent 8 }}
      {{- end }}
      {{- if $limit.maxLimitRequestRatio }}
      maxLimitRequestRatio:
{{ toYaml $limit.maxLimitRequestRatio | indent 8 }}
      {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.limitrange" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "limitrange" ) -}}
{{- end -}}

{{- define "libs.limitrange.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "limitrange" ) -}}
{{- end -}} 