gmusicbrowser-ppa:
  pkgrepo.managed:
    - ppa: andreas-boettger/gmusicbrowser-daily
  pkg.latest:
    - name: gmusicbrowser
    - refresh: True

gmusicbrowser:
  pkg:
    - installed
