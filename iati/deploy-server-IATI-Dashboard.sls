# The UNIX directory name and the path to that users home directory will need to be set in the Salt pillar. 
# Further infotmation about Salt pillars: http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html
#
# A YAML dictionary of this structure needs to both contain valid data and be available to this file
# dashboard:
#   unix-user-name: dashboard
#   unix-user-home-directory: /home/dashboard

include:
  - base
  - IATI-Registry-Refresher.deploy-IATI-Registry-Refresher
  - IATI-Stats.deploy-IATI-Stats
  - IATI-Dashboard.deploy-IATI-Dashboard

# Ensure there is a user 'dashboard'
{{ pillar['dashboard']['unix-user-name'] }}:
  user.present:
    - home: {{ pillar['dashboard']['unix-user-home-directory'] }}


###########################
# IATI-Registry-Refresher #
###########################

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
git config --global user.name "Dashboard":
  cmd.run:
    - user: dashboard

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
git config --global user.email "code@iatistandard.org":
  cmd.run:
    - user: dashboard

# Server
/usr/bin/gist:
  file.symlink:
    - target: /usr/bin/gist-paste

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
/home/dashboard/.netrc:
  file.managed:
    - source: salt://dashboard-netrc
    - user: dashboard
    - template: jinja

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
https://github.com/idsdata/IATI-Urls-Snapshot.git:
  git.latest:
    - rev: master
    - target: /home/dashboard/IATI-Registry-Refresher/urls
    - user: dashboard


##############
# IATI-Stats #
##############



##################
# IATI-Dashboard #
##################

# Tool
https://github.com/IATI/IATI-Dashboard.git:
  git.latest:
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live 
{% endif %}
    - target: /home/dashboard/IATI-Dashboard
    - user: dashboard

# Tool
dashboard-deps:
    pkg.installed:
        - pkgs:
            - libfreetype6-dev
            - libpng12-dev
            - pkg-config

# Tool
/home/dashboard/IATI-Dashboard/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: /home/dashboard/IATI-Dashboard/requirements.txt
        - require:
            - pkg: stats-deps
            - pkg: dashboard-deps

# Tool
/home/dashboard/IATI-Dashboard/config.py:
    file.managed:
        - source: salt://dashboard-config.py
        - user: dashboard
        - template: jinja

# Server
/home/dashboard/IATI-Stats/data:
  file.symlink:
    - target: /home/dashboard/IATI-Registry-Refresher/data
    - user: dashboard

# Server
/home/dashboard/IATI-Stats/helpers/ckan:
  file.symlink:
    - target: /home/dashboard/IATI-Registry-Refresher/ckan
    - user: dashboard

# Server
/home/dashboard/IATI-Stats/helpers/get_schemas.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

# Server
/home/dashboard/IATI-Stats/helpers/get_codelist_mapping.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

# Server
/home/dashboard/IATI-Stats/helpers/get_codelists.sh:
    cmd.run:
        - cwd: /home/dashboard/IATI-Stats/helpers/

# Server
https://github.com/IATI/IATI-Rulesets.git:
    git.latest:
        - rev: version-1.05
        - target: /home/dashboard/IATI-Stats/IATI-Rulesets/
        - user: dashboard

# Server
/home/dashboard/IATI-Stats/helpers/rulesets:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/IATI-Rulesets/rulesets

# Server
/home/dashboard/IATI-Dashboard/stats-calculated:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/gitout

# Server
/home/dashboard/IATI-Dashboard/stats-blacklist:
    file.symlink:
        - target: /home/dashboard/IATI-Stats/stats-blacklist

# Server
webserver-deps:
    pkg.installed:
        - pkgs:
            - apache2

/etc/apache2/sites-available/new.dashboard.conf:
  file.managed:
    - source: salt://dashboard-apache

# Server
/etc/apache2/sites-enabled/new.dashboard.conf:
    file.symlink:
        - target: /etc/apache2/sites-available/new.dashboard.conf

# Server
apache2:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/sites-available/new.dashboard.conf

# Server
/home/dashboard/full-dashboard-run.sh:
  file.managed:
    - source: salt://full-dashboard-run.sh
    - user: dashboard
    - mode: 755

# Server
/home/dashboard/logs:
  file.directory:
    - makedirs: True
    - user: dashboard
    - group: dashboard

# Server
/home/dashboard/full-dashboard-run.sh > /home/dashboard/logs/$(date +\%Y\%m\%d).log 2>&1:
  cron.present:
    - user: dashboard
    - minute: 1
{% if saltenv == 'dev' %}
    - hour: 6
{% else %}
    - hour: 0
{% endif %}

# Server
{% if saltenv != 'dev' %}
curl "http://iatiregistry.org/api/1/search/dataset?isopen=false&limit=200" | grep -o '"[^"]*"' | sed -e 's/"//g' -e 's/-.*//' | sort | uniq -c | gist -u 24beac7d23282f9b15f4 -f license_not_open:
  cron.present:
    - identifier: license-not-open-gist
    - user: dashboard
    - minute: 0
    - hour: 0
{% endif %}

