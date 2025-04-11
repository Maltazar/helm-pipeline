{{- define "libs.clusterrolebinding.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.clusterrolebindings }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ $val.roleRef.name }}
subjects:
{{- if $val.subjects }}
{{ toYaml $val.subjects | indent 2 }}
{{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.clusterrolebinding" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "clusterrolebinding" ) -}}
{{- end -}}

{{- define "libs.clusterrolebinding.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "clusterrolebinding" ) -}}
{{- end -}} 