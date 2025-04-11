{{- define "libs.job.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.jobs }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: batch/v1
kind: Job
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.completions }}
  completions: {{ $val.completions }}
  {{- end }}
  {{- if $val.parallelism }}
  parallelism: {{ $val.parallelism }}
  {{- end }}
  {{- if $val.backoffLimit }}
  backoffLimit: {{ $val.backoffLimit }}
  {{- end }}
  template:
    metadata:
      labels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 8 }}
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
{{ toYaml $cv.resources | indent 12 }}
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
{{ toYaml $cv.envFrom | indent 12 }}
          {{- end }}
          {{- if $cv.volumeMounts }}
          volumeMounts:
{{ toYaml $cv.volumeMounts | indent 12 }}
          {{- end }}
      {{- end }}
      {{- if $val.volumes }}
      volumes:
{{ toYaml $val.volumes | indent 8 }}
      {{- end }}
      {{- if $val.restartPolicy }}
      restartPolicy: {{ $val.restartPolicy }}
      {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.job" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "job" ) -}}
{{- end -}}

{{- define "libs.job.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "job" ) -}}
{{- end -}} 