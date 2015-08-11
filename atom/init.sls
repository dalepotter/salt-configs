atom-ppa:
  pkgrepo.managed:
    - ppa: webupd8team/atom
  pkg.latest:
    - name: atom
    - refresh: True

atom:
  pkg:
    - installed
