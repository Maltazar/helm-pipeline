{{- define "libs.cronjob.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.cronjobs }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: batch/v1
kind: CronJob
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  schedule: {{ $val.schedule }}
  {{- if $val.concurrencyPolicy }}
  concurrencyPolicy: {{ $val.concurrencyPolicy }}
  {{- end }}
  {{- if $val.suspend }}
  suspend: {{ $val.suspend }}
  {{- end }}
  {{- if $val.successfulJobsHistoryLimit }}
  successfulJobsHistoryLimit: {{ $val.successfulJobsHistoryLimit }}
  {{- end }}
  {{- if $val.failedJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ $val.failedJobsHistoryLimit }}
  {{- end }}
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 12 }}
        spec:
          containers:
          {{- range $cName, $cv := $val.containers }}
            - name: {{ $cName }}
              image: {{ $cv.image }}
              {{- if $cv.command }}
              command:
              {{- range $cmd := $cv.command }}
                - {{ $cmd }}
              {{- end }}
              {{- end }}
              {{- if $cv.args }}
              args:
              {{- range $arg := $cv.args }}
                - {{ $arg }}
              {{- end }}
              {{- end }}
              {{- if $cv.resources }}
              resources:
{{ toYaml $cv.resources | indent 16 }}
              {{- end }}
              {{- if $cv.env }}
              env:
              {{- range $env := $cv.env }}
                - name: {{ $env.name }}
                  value: {{ $env.value }}
              {{- end }}
              {{- end }}
              {{- if $cv.envFrom }}
              envFrom:
{{ toYaml $cv.envFrom | indent 16 }}
              {{- end }}
              {{- if $cv.volumeMounts }}
              volumeMounts:
{{ toYaml $cv.volumeMounts | indent 16 }}
              {{- end }}
          {{- end }}
          {{- if $val.volumes }}
          volumes:
{{ toYaml $val.volumes | indent 12 }}
          {{- end }}
          {{- if $val.restartPolicy }}
          restartPolicy: {{ $val.restartPolicy }}
          {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.cronjob" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "cronjob" ) -}}
{{- end -}}

{{- define "libs.cronjob.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "cronjob" ) -}}
{{- end -}} 