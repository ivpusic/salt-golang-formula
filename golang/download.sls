{% from "golang/map.jinja" import golang with context %}

{% set archive = '/tmp/golang-%s.tar.gz'|format(golang.version) %}

golang|cache-archive:
  file.managed:
    - name: {{archive}}
    - source: https://storage.googleapis.com/golang/go{{golang.version}}.linux-amd64.tar.gz
    - skip_verify: True
    - user: root
    - group: root
    - unless:
        - test -e {{ archive }}
