{{- define "libs.rolebinding.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.rolebindings }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ $val.roleRef.name }}
subjects:
{{- if $val.subjects }}
{{ toYaml $val.subjects | indent 2 }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.rolebinding" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "rolebinding" ) -}}
{{- end -}}

{{- define "libs.rolebinding.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "rolebinding" ) -}}
{{- end -}} 