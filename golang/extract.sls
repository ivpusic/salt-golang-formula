{% from "golang/map.jinja" import golang with context %}

{% set archive = '/tmp/golang-%s.tar.gz'|format(golang.version) %}

golang|extract-archive:
  file.directory:
    - names:
        - {{ golang.base_dir }}
        - {{ golang.go_path }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - unless:
        - test -d {{ golang.base_dir }}
    - recurse:
        - user
        - group
        - mode

  archive.extracted:
    - name: {{ golang.base_dir }}
    - source: {{archive}}
    - archive_format: tar
    - overwrite: True
    - clean: True
    - user: root
    - group: root
    - options: v
    - watch:
        - file: golang|cache-archive
    - unless:
        - go version | grep {{ golang.version }}
