apache:
  pkg:
    - installed
    - pkgs:
      - apache2
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pkg: apache2
    - watch:
      - file: /etc/apache2/*
      - pkg: apache2
