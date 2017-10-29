{% from "golang/map.jinja" import golang with context -%}
{% set env_path = salt['environ.get']('PATH') %}
{% set env_path = env_path ~ ':' ~ golang.go_root %}

golang|set-goroot:
  environ.setenv:
    - name: GOROOT
    - value: {{ golang.go_root }}
    - update_minion: True

golang|set-gopath:
  environ.setenv:
    - name: GOPATH
    - value: {{ golang.go_path }}
    - update_minion: True

golang|update-path:
  environ.setenv:
    - name: PATH
    - value: {{ env_path }}
    - update_minion: True

/root/.bashrc:
  file.append:
    - text:
      - export GOROOT={{ golang.go_root }}
      - export GOPATH={{ golang.go_path }}
      - export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
