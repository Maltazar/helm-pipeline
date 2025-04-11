{{- define "libs.verticalpodautoscaler.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.verticalpodautoscalers }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  targetRef:
    apiVersion: {{ $val.targetRef.apiVersion | default "apps/v1" }}
    kind: {{ $val.targetRef.kind }}
    name: {{ $val.targetRef.name }}
  {{- if $val.updatePolicy }}
  updatePolicy:
{{ toYaml $val.updatePolicy | indent 4 }}
  {{- end }}
  {{- if $val.resourcePolicy }}
  resourcePolicy:
{{ toYaml $val.resourcePolicy | indent 4 }}
  {{- end }}
  {{- if $val.recommenders }}
  recommenders:
  {{- range $recommender := $val.recommenders }}
    - name: {{ $recommender.name }}
  {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.verticalpodautoscaler" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "verticalpodautoscaler" ) -}}
{{- end -}}

{{- define "libs.verticalpodautoscaler.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "verticalpodautoscaler" ) -}}
{{- end -}} 