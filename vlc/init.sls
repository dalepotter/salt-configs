vlc-ppa:
  pkgrepo.managed:
    - ppa: videolan/stable-daily
  pkg.latest:
    - name: vlc
    - refresh: True

vlc:
  pkg:
    - installed
