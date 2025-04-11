{{- define "libs.deployment.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.deployments }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: apps/v1
kind: Deployment
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
{{- if $val.spec }}
{{ toYaml $val.spec | indent 2 }}
{{- end }}
  selector:
    matchLabels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 6 }}
  template:
    metadata:
      labels:
{{ include "helper.set.selectors" (list $all $app $val) | indent 8 }}
    spec:
      containers:
      {{- range $cName, $cv := $val.containers }}
        - name: {{ $cName }}
          image: {{ $cv.image }}
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
      {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.deployment" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "deployment" ) -}}
{{- end -}}

{{- define "libs.deployment.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "deployment" ) -}}
{{- end -}} 