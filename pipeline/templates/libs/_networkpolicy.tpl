{{- define "libs.networkpolicy.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.networkpolicies }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  podSelector:
{{ include "helper.set.selectors" (list $all $app $val) | indent 4 }}
  {{- if $val.policyTypes }}
  policyTypes:
  {{- range $type := $val.policyTypes }}
    - {{ $type }}
  {{- end }}
  {{- end }}
  {{- if $val.ingress }}
  ingress:
  {{- range $rule := $val.ingress }}
    - {{- if $rule.from }}
      from:
      {{- range $from := $rule.from }}
        {{- if $from.podSelector }}
        - podSelector:
{{ toYaml $from.podSelector | indent 12 }}
        {{- end }}
        {{- if $from.namespaceSelector }}
        - namespaceSelector:
{{ toYaml $from.namespaceSelector | indent 12 }}
        {{- end }}
        {{- if $from.ipBlock }}
        - ipBlock:
{{ toYaml $from.ipBlock | indent 12 }}
        {{- end }}
      {{- end }}
      {{- end }}
      {{- if $rule.ports }}
      ports:
      {{- range $port := $rule.ports }}
        - protocol: {{ $port.protocol | default "TCP" }}
          {{- if $port.port }}
          port: {{ $port.port }}
          {{- end }}
          {{- if $port.endPort }}
          endPort: {{ $port.endPort }}
          {{- end }}
      {{- end }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- if $val.egress }}
  egress:
  {{- range $rule := $val.egress }}
    - {{- if $rule.to }}
      to:
      {{- range $to := $rule.to }}
        {{- if $to.podSelector }}
        - podSelector:
{{ toYaml $to.podSelector | indent 12 }}
        {{- end }}
        {{- if $to.namespaceSelector }}
        - namespaceSelector:
{{ toYaml $to.namespaceSelector | indent 12 }}
        {{- end }}
        {{- if $to.ipBlock }}
        - ipBlock:
{{ toYaml $to.ipBlock | indent 12 }}
        {{- end }}
      {{- end }}
      {{- end }}
      {{- if $rule.ports }}
      ports:
      {{- range $port := $rule.ports }}
        - protocol: {{ $port.protocol | default "TCP" }}
          {{- if $port.port }}
          port: {{ $port.port }}
          {{- end }}
          {{- if $port.endPort }}
          endPort: {{ $port.endPort }}
          {{- end }}
      {{- end }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.networkpolicy" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "networkpolicy" ) -}}
{{- end -}}

{{- define "libs.networkpolicy.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "networkpolicy" ) -}}
{{- end -}} 