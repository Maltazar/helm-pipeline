{{- define "libs.horizontalpodautoscaler.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.horizontalpodautoscalers }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ $val.targetRef.name }}
  minReplicas: {{ $val.minReplicas | default 1 }}
  maxReplicas: {{ $val.maxReplicas }}
  {{- if $val.metrics }}
  metrics:
  {{- range $metric := $val.metrics }}
    - type: {{ $metric.type }}
      {{- if eq $metric.type "Resource" }}
      resource:
        name: {{ $metric.resource.name }}
        target:
          type: {{ $metric.resource.target.type }}
          averageUtilization: {{ $metric.resource.target.averageUtilization }}
      {{- end }}
      {{- if eq $metric.type "Pods" }}
      pods:
        metric:
          name: {{ $metric.pods.metric.name }}
        target:
          type: {{ $metric.pods.target.type }}
          averageValue: {{ $metric.pods.target.averageValue }}
      {{- end }}
      {{- if eq $metric.type "Object" }}
      object:
        metric:
          name: {{ $metric.object.metric.name }}
        describedObject:
          apiVersion: {{ $metric.object.describedObject.apiVersion }}
          kind: {{ $metric.object.describedObject.kind }}
          name: {{ $metric.object.describedObject.name }}
        target:
          type: {{ $metric.object.target.type }}
          value: {{ $metric.object.target.value }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- if $val.behavior }}
  behavior:
{{ toYaml $val.behavior | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.horizontalpodautoscaler" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "horizontalpodautoscaler" ) -}}
{{- end -}}

{{- define "libs.horizontalpodautoscaler.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "horizontalpodautoscaler" ) -}}
{{- end -}} 