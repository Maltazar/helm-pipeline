{{- define "libs.serviceaccount.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.serviceaccounts }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: ServiceAccount
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
  {{- if $val.automountServiceAccountToken }}
automountServiceAccountToken: {{ $val.automountServiceAccountToken }}
  {{- end }}
  {{- if $val.imagePullSecrets }}
imagePullSecrets:
{{ toYaml $val.imagePullSecrets | indent 2 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.serviceaccount" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "serviceaccount" ) -}}
{{- end -}}

{{- define "libs.serviceaccount.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "serviceaccount" ) -}}
{{- end -}} 