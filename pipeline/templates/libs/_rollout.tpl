{{- define "libs.rollout.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.rollouts }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.replicas }}
  replicas: {{ $val.replicas }}
  {{- end }}
  {{- if $val.selector }}
  selector:
{{ toYaml $val.selector | indent 4 }}
  {{- end }}
  {{- if $val.template }}
  template:
{{ toYaml $val.template | indent 4 }}
  {{- end }}
  {{- if $val.strategy }}
  strategy:
    {{- if $val.strategy.blueGreen }}
    blueGreen:
{{ toYaml $val.strategy.blueGreen | indent 6 }}
    {{- end }}
    {{- if $val.strategy.canary }}
    canary:
{{ toYaml $val.strategy.canary | indent 6 }}
    {{- end }}
  {{- end }}
  {{- if $val.minReadySeconds }}
  minReadySeconds: {{ $val.minReadySeconds }}
  {{- end }}
  {{- if $val.revisionHistoryLimit }}
  revisionHistoryLimit: {{ $val.revisionHistoryLimit }}
  {{- end }}
  {{- if $val.paused }}
  paused: {{ $val.paused }}
  {{- end }}
  {{- if $val.progressDeadlineSeconds }}
  progressDeadlineSeconds: {{ $val.progressDeadlineSeconds }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.rollout" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "rollout" ) -}}
{{- end -}}

{{- define "libs.rollout.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "rollout" ) -}}
{{- end -}} 