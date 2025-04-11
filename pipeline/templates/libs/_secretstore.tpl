{{- define "libs.secretstore.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.secretstores }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  {{- if $val.provider }}
  provider:
    {{- if $val.provider.aws }}
    aws:
{{ toYaml $val.provider.aws | indent 6 }}
    {{- end }}
    {{- if $val.provider.azurekv }}
    azurekv:
{{ toYaml $val.provider.azurekv | indent 6 }}
    {{- end }}
    {{- if $val.provider.gcpsm }}
    gcpsm:
{{ toYaml $val.provider.gcpsm | indent 6 }}
    {{- end }}
    {{- if $val.provider.ibm }}
    ibm:
{{ toYaml $val.provider.ibm | indent 6 }}
    {{- end }}
    {{- if $val.provider.akeyless }}
    akeyless:
{{ toYaml $val.provider.akeyless | indent 6 }}
    {{- end }}
    {{- if $val.provider.alibaba }}
    alibaba:
{{ toYaml $val.provider.alibaba | indent 6 }}
    {{- end }}
    {{- if $val.provider.doppler }}
    doppler:
{{ toYaml $val.provider.doppler | indent 6 }}
    {{- end }}
    {{- if $val.provider.fake }}
    fake:
{{ toYaml $val.provider.fake | indent 6 }}
    {{- end }}
    {{- if $val.provider.gitlab }}
    gitlab:
{{ toYaml $val.provider.gitlab | indent 6 }}
    {{- end }}
    {{- if $val.provider.hashicorp }}
    hashicorp:
{{ toYaml $val.provider.hashicorp | indent 6 }}
    {{- end }}
    {{- if $val.provider.kubernetes }}
    kubernetes:
{{ toYaml $val.provider.kubernetes | indent 6 }}
    {{- end }}
    {{- if $val.provider.onepassword }}
    onepassword:
{{ toYaml $val.provider.onepassword | indent 6 }}
    {{- end }}
    {{- if $val.provider.oracle }}
    oracle:
{{ toYaml $val.provider.oracle | indent 6 }}
    {{- end }}
    {{- if $val.provider.scaleway }}
    scaleway:
{{ toYaml $val.provider.scaleway | indent 6 }}
    {{- end }}
    {{- if $val.provider.senhaseguros }}
    senhaseguros:
{{ toYaml $val.provider.senhaseguros | indent 6 }}
    {{- end }}
    {{- if $val.provider.vault }}
    vault:
{{ toYaml $val.provider.vault | indent 6 }}
    {{- end }}
    {{- if $val.provider.webhook }}
    webhook:
{{ toYaml $val.provider.webhook | indent 6 }}
    {{- end }}
    {{- if $val.provider.yandexcertificatemanager }}
    yandexcertificatemanager:
{{ toYaml $val.provider.yandexcertificatemanager | indent 6 }}
    {{- end }}
    {{- if $val.provider.yandexlockbox }}
    yandexlockbox:
{{ toYaml $val.provider.yandexlockbox | indent 6 }}
    {{- end }}
  {{- end }}
  {{- if $val.retrySettings }}
  retrySettings:
{{ toYaml $val.retrySettings | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.secretstore" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "secretstore" ) -}}
{{- end -}}

{{- define "libs.secretstore.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "secretstore" ) -}}
{{- end -}} 