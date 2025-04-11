{{- define "libs.ciliumclusterwidenetworkpolicy.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.ciliumclusterwidenetworkpolicies }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: cilium.io/v2
kind: CiliumClusterwideNetworkPolicy
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.description }}
  description: {{ $val.description }}
  {{- end }}
  {{- if $val.endpointSelector }}
  endpointSelector:
{{ toYaml $val.endpointSelector | indent 4 }}
  {{- end }}
  {{- if $val.nodeSelector }}
  nodeSelector:
{{ toYaml $val.nodeSelector | indent 4 }}
  {{- end }}
  {{- if $val.ingress }}
  ingress:
  {{- range $rule := $val.ingress }}
    - {{- if $rule.fromEndpoints }}
      fromEndpoints:
      {{- range $endpoint := $rule.fromEndpoints }}
        - matchLabels:
{{ toYaml $endpoint.matchLabels | indent 12 }}
      {{- end }}
      {{- end }}
      {{- if $rule.fromCIDR }}
      fromCIDR:
      {{- range $cidr := $rule.fromCIDR }}
        - {{ $cidr }}
      {{- end }}
      {{- end }}
      {{- if $rule.fromCIDRSet }}
      fromCIDRSet:
      {{- range $cidrSet := $rule.fromCIDRSet }}
        - cidr: {{ $cidrSet.cidr }}
          {{- if $cidrSet.except }}
          except:
          {{- range $except := $cidrSet.except }}
            - {{ $except }}
          {{- end }}
          {{- end }}
      {{- end }}
      {{- end }}
      {{- if $rule.fromEntities }}
      fromEntities:
      {{- range $entity := $rule.fromEntities }}
        - {{ $entity }}
      {{- end }}
      {{- end }}
      {{- if $rule.toPorts }}
      toPorts:
      {{- range $port := $rule.toPorts }}
        - ports:
          {{- range $p := $port.ports }}
            - port: {{ $p.port }}
              protocol: {{ $p.protocol | default "TCP" }}
          {{- end }}
          {{- if $port.rules }}
          rules:
{{ toYaml $port.rules | indent 12 }}
          {{- end }}
      {{- end }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- if $val.egress }}
  egress:
  {{- range $rule := $val.egress }}
    - {{- if $rule.toEndpoints }}
      toEndpoints:
      {{- range $endpoint := $rule.toEndpoints }}
        - matchLabels:
{{ toYaml $endpoint.matchLabels | indent 12 }}
      {{- end }}
      {{- end }}
      {{- if $rule.toCIDR }}
      toCIDR:
      {{- range $cidr := $rule.toCIDR }}
        - {{ $cidr }}
      {{- end }}
      {{- end }}
      {{- if $rule.toCIDRSet }}
      toCIDRSet:
      {{- range $cidrSet := $rule.toCIDRSet }}
        - cidr: {{ $cidrSet.cidr }}
          {{- if $cidrSet.except }}
          except:
          {{- range $except := $cidrSet.except }}
            - {{ $except }}
          {{- end }}
          {{- end }}
      {{- end }}
      {{- end }}
      {{- if $rule.toEntities }}
      toEntities:
      {{- range $entity := $rule.toEntities }}
        - {{ $entity }}
      {{- end }}
      {{- end }}
      {{- if $rule.toPorts }}
      toPorts:
      {{- range $port := $rule.toPorts }}
        - ports:
          {{- range $p := $port.ports }}
            - port: {{ $p.port }}
              protocol: {{ $p.protocol | default "TCP" }}
          {{- end }}
          {{- if $port.rules }}
          rules:
{{ toYaml $port.rules | indent 12 }}
          {{- end }}
      {{- end }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.ciliumclusterwidenetworkpolicy" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "ciliumclusterwidenetworkpolicy" ) -}}
{{- end -}}

{{- define "libs.ciliumclusterwidenetworkpolicy.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "ciliumclusterwidenetworkpolicy" ) -}}
{{- end -}} 