{{- define "libs.persistentvolumeclaim.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.persistentvolumeclaims }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  accessModes:
  {{- range $mode := $val.accessModes }}
    - {{ $mode }}
  {{- end }}
  {{- if $val.storageClassName }}
  storageClassName: {{ $val.storageClassName }}
  {{- end }}
  resources:
    requests:
      storage: {{ $val.storage }}
  {{- if $val.selector }}
  selector:
{{ toYaml $val.selector | indent 4 }}
  {{- end }}
  {{- if $val.volumeName }}
  volumeName: {{ $val.volumeName }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.persistentvolumeclaim" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "persistentvolumeclaim" ) -}}
{{- end -}}

{{- define "libs.persistentvolumeclaim.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "persistentvolumeclaim" ) -}}
{{- end -}} 