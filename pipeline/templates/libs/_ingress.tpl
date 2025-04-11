{{- define "libs.ingress.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.ingresses }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
{{- if $val.spec }}
{{ toYaml $val.spec | indent 2 }}
{{- end }}
  rules:
  {{- range $rule := $val.rules }}
    - host: {{ $rule.host }}
      http:
        paths:
        {{- range $path := $rule.paths }}
          - path: {{ $path.path }}
            pathType: {{ $path.pathType | default "Prefix" }}
            backend:
              service:
                name: {{ $path.serviceName }}
                port:
                  number: {{ $path.servicePort }}
        {{- end }}
  {{- end }}
  {{- if $val.tls }}
  tls:
  {{- range $tls := $val.tls }}
    - hosts:
      {{- range $host := $tls.hosts }}
        - {{ $host }}
      {{- end }}
      {{- if $tls.secretName }}
      secretName: {{ $tls.secretName }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.ingress" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "ingress" ) -}}
{{- end -}}

{{- define "libs.ingress.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "ingress" ) -}}
{{- end -}} 