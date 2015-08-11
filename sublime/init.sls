sublime3-ppa:
  pkgrepo.managed:
    - ppa: webupd8team/sublime-text-3
  pkg.latest:
    - name: sublime3
    - refresh: True

sublime-text-installer:
  pkg:
    - installed
