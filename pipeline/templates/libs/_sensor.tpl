{{- define "libs.sensor.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.sensors }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: argoproj.io/v1alpha1
kind: Sensor
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.dependencies }}
  dependencies:
  {{- range $dep := $val.dependencies }}
    - name: {{ $dep.name }}
      eventSourceName: {{ $dep.eventSourceName }}
      eventName: {{ $dep.eventName }}
      {{- if $dep.filters }}
      filters:
{{ toYaml $dep.filters | indent 8 }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- if $val.triggers }}
  triggers:
  {{- range $trigger := $val.triggers }}
    - template:
        name: {{ $trigger.template.name }}
        {{- if $trigger.template.conditions }}
        conditions: {{ $trigger.template.conditions }}
        {{- end }}
        {{- if $trigger.template.k8s }}
        k8s:
{{ toYaml $trigger.template.k8s | indent 10 }}
        {{- end }}
        {{- if $trigger.template.argoWorkflow }}
        argoWorkflow:
{{ toYaml $trigger.template.argoWorkflow | indent 10 }}
        {{- end }}
        {{- if $trigger.template.http }}
        http:
{{ toYaml $trigger.template.http | indent 10 }}
        {{- end }}
        {{- if $trigger.template.awsLambda }}
        awsLambda:
{{ toYaml $trigger.template.awsLambda | indent 10 }}
        {{- end }}
        {{- if $trigger.template.custom }}
        custom:
{{ toYaml $trigger.template.custom | indent 10 }}
        {{- end }}
        {{- if $trigger.template.nats }}
        nats:
{{ toYaml $trigger.template.nats | indent 10 }}
        {{- end }}
        {{- if $trigger.template.kafka }}
        kafka:
{{ toYaml $trigger.template.kafka | indent 10 }}
        {{- end }}
        {{- if $trigger.template.slack }}
        slack:
{{ toYaml $trigger.template.slack | indent 10 }}
        {{- end }}
        {{- if $trigger.template.openWhisk }}
        openWhisk:
{{ toYaml $trigger.template.openWhisk | indent 10 }}
        {{- end }}
        {{- if $trigger.template.log }}
        log:
{{ toYaml $trigger.template.log | indent 10 }}
        {{- end }}
  {{- end }}
  {{- end }}
  {{- if $val.template }}
  template:
{{ toYaml $val.template | indent 4 }}
  {{- end }}
  {{- if $val.errorOnFailedRound }}
  errorOnFailedRound: {{ $val.errorOnFailedRound }}
  {{- end }}
  {{- if $val.replicas }}
  replicas: {{ $val.replicas }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.sensor" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "sensor" ) -}}
{{- end -}}

{{- define "libs.sensor.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "sensor" ) -}}
{{- end -}} 