{{- define "libs.eventsource.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.eventsources }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: argoproj.io/v1alpha1
kind: EventSource
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.service }}
  service:
{{ toYaml $val.service | indent 4 }}
  {{- end }}
  {{- if $val.minio }}
  minio:
{{ toYaml $val.minio | indent 4 }}
  {{- end }}
  {{- if $val.calendar }}
  calendar:
{{ toYaml $val.calendar | indent 4 }}
  {{- end }}
  {{- if $val.file }}
  file:
{{ toYaml $val.file | indent 4 }}
  {{- end }}
  {{- if $val.resource }}
  resource:
{{ toYaml $val.resource | indent 4 }}
  {{- end }}
  {{- if $val.webhook }}
  webhook:
{{ toYaml $val.webhook | indent 4 }}
  {{- end }}
  {{- if $val.amqp }}
  amqp:
{{ toYaml $val.amqp | indent 4 }}
  {{- end }}
  {{- if $val.kafka }}
  kafka:
{{ toYaml $val.kafka | indent 4 }}
  {{- end }}
  {{- if $val.mqtt }}
  mqtt:
{{ toYaml $val.mqtt | indent 4 }}
  {{- end }}
  {{- if $val.nats }}
  nats:
{{ toYaml $val.nats | indent 4 }}
  {{- end }}
  {{- if $val.sns }}
  sns:
{{ toYaml $val.sns | indent 4 }}
  {{- end }}
  {{- if $val.sqs }}
  sqs:
{{ toYaml $val.sqs | indent 4 }}
  {{- end }}
  {{- if $val.pubsub }}
  pubsub:
{{ toYaml $val.pubsub | indent 4 }}
  {{- end }}
  {{- if $val.github }}
  github:
{{ toYaml $val.github | indent 4 }}
  {{- end }}
  {{- if $val.gitlab }}
  gitlab:
{{ toYaml $val.gitlab | indent 4 }}
  {{- end }}
  {{- if $val.hdfs }}
  hdfs:
{{ toYaml $val.hdfs | indent 4 }}
  {{- end }}
  {{- if $val.slack }}
  slack:
{{ toYaml $val.slack | indent 4 }}
  {{- end }}
  {{- if $val.storagegrid }}
  storagegrid:
{{ toYaml $val.storagegrid | indent 4 }}
  {{- end }}
  {{- if $val.azureEventsHub }}
  azureEventsHub:
{{ toYaml $val.azureEventsHub | indent 4 }}
  {{- end }}
  {{- if $val.stripe }}
  stripe:
{{ toYaml $val.stripe | indent 4 }}
  {{- end }}
  {{- if $val.emitter }}
  emitter:
{{ toYaml $val.emitter | indent 4 }}
  {{- end }}
  {{- if $val.redis }}
  redis:
{{ toYaml $val.redis | indent 4 }}
  {{- end }}
  {{- if $val.azureQueueStorage }}
  azureQueueStorage:
{{ toYaml $val.azureQueueStorage | indent 4 }}
  {{- end }}
  {{- if $val.generic }}
  generic:
{{ toYaml $val.generic | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.eventsource" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "eventsource" ) -}}
{{- end -}}

{{- define "libs.eventsource.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "eventsource" ) -}}
{{- end -}} 