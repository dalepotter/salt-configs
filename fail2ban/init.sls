fail2ban:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pkg: fail2ban
    - watch:
      - file: /etc/fail2ban/*
      - pkg: fail2ban

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://fail2ban/jail.local
