{{- define "libs.daemonset.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.daemonsets }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: apps/v1
kind: DaemonSet
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.updateStrategy }}
  updateStrategy:
{{ toYaml $val.updateStrategy | indent 4 }}
  {{- end }}
  selector:
    matchLabels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 6 }}
  template:
    metadata:
      labels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 8 }}
    spec:
      {{- if $val.nodeSelector }}
      nodeSelector:
{{ toYaml $val.nodeSelector | indent 8 }}
      {{- end }}
      {{- if $val.tolerations }}
      tolerations:
{{ toYaml $val.tolerations | indent 8 }}
      {{- end }}
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
          {{- if $cv.ports }}
          ports:
          {{- range $pName, $pv := $cv.ports }}
            - name: {{ $pName }}
              containerPort: {{ $pv }}
              protocol: TCP
          {{- end }}
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
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.daemonset" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "daemonset" ) -}}
{{- end -}}

{{- define "libs.daemonset.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "daemonset" ) -}}
{{- end -}} 