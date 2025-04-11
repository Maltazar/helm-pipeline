{{- define "libs.resourcequota.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.resourcequotas }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: ResourceQuota
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.hard }}
  hard:
{{ toYaml $val.hard | indent 4 }}
  {{- end }}
  {{- if $val.scopes }}
  scopes:
  {{- range $scope := $val.scopes }}
    - {{ $scope }}
  {{- end }}
  {{- end }}
  {{- if $val.scopeSelector }}
  scopeSelector:
{{ toYaml $val.scopeSelector | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.resourcequota" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "resourcequota" ) -}}
{{- end -}}

{{- define "libs.resourcequota.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "resourcequota" ) -}}
{{- end -}} 