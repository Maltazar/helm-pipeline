{{- define "libs.poddisruptionbudget.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.poddisruptionbudgets }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.minAvailable }}
  minAvailable: {{ $val.minAvailable }}
  {{- end }}
  {{- if $val.maxUnavailable }}
  maxUnavailable: {{ $val.maxUnavailable }}
  {{- end }}
  selector:
{{ include "helper.set.selectors" (list $all $app $val) | indent 4 }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.poddisruptionbudget" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "poddisruptionbudget" ) -}}
{{- end -}}

{{- define "libs.poddisruptionbudget.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "poddisruptionbudget" ) -}}
{{- end -}} 