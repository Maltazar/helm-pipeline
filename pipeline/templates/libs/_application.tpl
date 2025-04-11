{{- define "libs.application.tpl" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- $v := index . 2 -}}

{{- range $name, $val := $v.applications }}
  {{- if kindIs "map" $val }}
  {{- $_ := set $val "naming" $v.naming -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
{{ include "helper.set.labels" (list $all $app $val) | indent 2 }}
{{ include "helper.set.annotations" (list $all $app $val) | indent 2 }}
  name: {{ $name }}
spec:
  project: {{ $val.project }}
  source:
    repoURL: {{ $val.source.repoURL }}
    targetRevision: {{ $val.source.targetRevision }}
    {{- if $val.source.path }}
    path: {{ $val.source.path }}
    {{- end }}
    {{- if $val.source.helm }}
    helm:
{{ toYaml $val.source.helm | indent 6 }}
    {{- end }}
    {{- if $val.source.kustomize }}
    kustomize:
{{ toYaml $val.source.kustomize | indent 6 }}
    {{- end }}
    {{- if $val.source.directory }}
    directory:
{{ toYaml $val.source.directory | indent 6 }}
    {{- end }}
    {{- if $val.source.plugin }}
    plugin:
{{ toYaml $val.source.plugin | indent 6 }}
    {{- end }}
  destination:
    server: {{ $val.destination.server }}
    namespace: {{ $val.destination.namespace }}
  {{- if $val.syncPolicy }}
  syncPolicy:
    {{- if $val.syncPolicy.automated }}
    automated:
{{ toYaml $val.syncPolicy.automated | indent 6 }}
    {{- end }}
    {{- if $val.syncPolicy.syncOptions }}
    syncOptions:
{{ toYaml $val.syncPolicy.syncOptions | indent 6 }}
    {{- end }}
    {{- if $val.syncPolicy.retry }}
    retry:
{{ toYaml $val.syncPolicy.retry | indent 6 }}
    {{- end }}
  {{- end }}
  {{- if $val.ignoreDifferences }}
  ignoreDifferences:
{{ toYaml $val.ignoreDifferences | indent 4 }}
  {{- end }}
  {{- if $val.info }}
  info:
{{ toYaml $val.info | indent 4 }}
  {{- end }}
  {{- end }}
---
{{ end }}
{{- end -}}

{{- define "libs.application" -}}
{{- $all := index . 0 -}}
{{- $app := index . 1 -}}
{{- include "helper.no.merge" (list $all $app "application" ) -}}
{{- end -}}

{{- define "libs.application.otherContainters" -}}
{{- include "helper.merge.otherContainters" (list . "application" ) -}}
{{- end -}} 