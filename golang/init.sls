{% from "golang/map.jinja" import golang with context %}

{% set archive = "/tmp/golang-{{version}}.tar.gz" %}

golang|cache-archive:
  file.managed:
    - name: "{{archive}}"
    - source: https://redirector.gvt1.com/edgedl/go/go{{golang.version}}.linux-amd64.tar.gz
    - skip_verify: True
    - user: root
    - group: root
    - unless:
        - which go
        - test -x {{ golang.base_dir }}/go/bin/go

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
    - source: "{{archive}}"
    - archive_format: tar
    - user: root
    - group: root
    - options: v
    - watch:
        - file: golang|cache-archive
    - unless:
        - go version | grep {{ golang.version }}
        - test -x {{ golang.base_dir }}/go/bin/go

# sets up the necessary environment variables required for golang usage
golang|setup-bash-profile:
  file.managed:
    - name: /etc/profile.d/golang.sh
    - source:
        - salt://golang/files/go_profile.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
