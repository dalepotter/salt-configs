
# The UNIX directory name and the path to that users home directory will need to be set in the Salt pillar.
# Further infotmation about Salt pillars: http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html
#
# A YAML dictionary of this structure needs to both contain valid data and be available to this file
# registry-refresher:
#   unix-user-name: registry-refresher
#   unix-user-home-directory: /home/registry-refresher

# Install dependencies
registry-refresher-deps:
  pkg.installed:
    - pkgs:
      - curl
      - git-core
      - php5-cli
      - php5-curl
      - libxml2-utils
      - gist
      - zip

# Clone git repo
https://github.com/IATI/IATI-Registry-Refresher.git:
  git.latest:
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live
{% endif %}
    - target: {{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Registry-Refresher
    - user: {{ pillar['registry-refresher']['unix-user-name'] }}

# Genereate directories 
{{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Registry-Refresher/ckan:
  file.directory:
    - makedirs: True
    - user: {{ pillar['registry-refresher']['unix-user-name'] }}
    - group: {{ pillar['registry-refresher']['unix-user-name'] }}

{{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Registry-Refresher/zips:
  file.directory:
    - makedirs: True
    - user: {{ pillar['registry-refresher']['unix-user-name'] }}
    - group: {{ pillar['registry-refresher']['unix-user-name'] }}

