{{- define "libs.workflow.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.workflows }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.entrypoint }}
  entrypoint: {{ $val.entrypoint }}
  {{- end }}
  {{- if $val.templates }}
  templates:
{{ toYaml $val.templates | indent 4 }}
  {{- end }}
  {{- if $val.arguments }}
  arguments:
{{ toYaml $val.arguments | indent 4 }}
  {{- end }}
  {{- if $val.serviceAccountName }}
  serviceAccountName: {{ $val.serviceAccountName }}
  {{- end }}
  {{- if $val.volumes }}
  volumes:
{{ toYaml $val.volumes | indent 4 }}
  {{- end }}
  {{- if $val.volumeClaimTemplates }}
  volumeClaimTemplates:
{{ toYaml $val.volumeClaimTemplates | indent 4 }}
  {{- end }}
  {{- if $val.podGC }}
  podGC:
{{ toYaml $val.podGC | indent 4 }}
  {{- end }}
  {{- if $val.ttlStrategy }}
  ttlStrategy:
{{ toYaml $val.ttlStrategy | indent 4 }}
  {{- end }}
  {{- if $val.priority }}
  priority: {{ $val.priority }}
  {{- end }}
  {{- if $val.podPriorityClassName }}
  podPriorityClassName: {{ $val.podPriorityClassName }}
  {{- end }}
  {{- if $val.imagePullSecrets }}
  imagePullSecrets:
{{ toYaml $val.imagePullSecrets | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.workflow" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "workflow" ) -}}
{{- end -}}

{{- define "libs.workflow.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "workflow" ) -}}
{{- end -}} 