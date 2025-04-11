{{- define "libs.role.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.roles }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
rules:
{{- if $val.rules }}
{{ toYaml $val.rules | indent 2 }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.role" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "role" ) -}}
{{- end -}}

{{- define "libs.role.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "role" ) -}}
{{- end -}} 