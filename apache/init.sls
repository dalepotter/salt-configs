apache:
  pkg:
    - installed
    - pkgs:
      - apache2
  service:
    - running
    - require:
      - pkg: apache2
