# For configuting Dale's Ubuntu laptop with a set of software packages.
# To run:
# 1) Run 'sudo apt-get install salt-minion'
# 2) Change the '/etc/salt/minion' config file to: 'master: <IP Address of Master>'
# 3) Run 'sudo service salt-minion restart'
# 4) Run 'state.sls laptop' on the master
# N.B. May take some time to run


## General software

laptop_software:
  pkg:
    - installed
    - pkgs:
      - python-software-properties
      - libreoffice
      - gedit
      - chromium-browser


## Coding tools

atom-ppa:
  pkgrepo.managed:
    - ppa: webupd8team/atom
  pkg.latest:
    - name: atom
    - refresh: True

atom:
  pkg:
    - installed

sublime3-ppa:
  pkgrepo.managed:
    - ppa: webupd8team/sublime-text-3
  pkg.latest:
    - name: sublime3
    - refresh: True

sublime-text-installer:
  pkg:
    - installed


## Media

# Gmusicbrowser
gmusicbrowser-ppa:
  pkgrepo.managed:
    - ppa: andreas-boettger/gmusicbrowser-daily
  pkg.latest:
    - name: gmusicbrowser
    - refresh: True

gmusicbrowser:
  pkg:
    - installed

# VLC media player
vlc-ppa:
  pkgrepo.managed:
    - ppa: videolan/stable-daily
  pkg.latest:
    - name: vlc
    - refresh: True

vlc:
  pkg:
    - installed

