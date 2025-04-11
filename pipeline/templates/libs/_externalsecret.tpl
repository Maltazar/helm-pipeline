{{- define "libs.externalsecret.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.externalsecrets }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  refreshInterval: {{ $val.refreshInterval | default "1h" }}
  secretStoreRef:
    name: {{ $val.secretStoreRef.name }}
    kind: {{ $val.secretStoreRef.kind | default "SecretStore" }}
  {{- if $val.target }}
  target:
    name: {{ $val.target.name }}
    {{- if $val.target.creationPolicy }}
    creationPolicy: {{ $val.target.creationPolicy }}
    {{- end }}
    {{- if $val.target.deletionPolicy }}
    deletionPolicy: {{ $val.target.deletionPolicy }}
    {{- end }}
    {{- if $val.target.template }}
    template:
{{ toYaml $val.target.template | indent 6 }}
    {{- end }}
  {{- end }}
  data:
  {{- range $data := $val.data }}
    - secretKey: {{ $data.secretKey }}
      remoteRef:
        key: {{ $data.remoteRef.key }}
        {{- if $data.remoteRef.property }}
        property: {{ $data.remoteRef.property }}
        {{- end }}
        {{- if $data.remoteRef.version }}
        version: {{ $data.remoteRef.version }}
        {{- end }}
  {{- end }}
  {{- if $val.dataFrom }}
  dataFrom:
  {{- range $dataFrom := $val.dataFrom }}
    - extract:
        key: {{ $dataFrom.extract.key }}
        {{- if $dataFrom.extract.property }}
        property: {{ $dataFrom.extract.property }}
        {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.externalsecret" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "externalsecret" ) -}}
{{- end -}}

{{- define "libs.externalsecret.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "externalsecret" ) -}}
{{- end -}} 