# The UNIX directory name and the path to that users home directory will need to be set in the Salt pillar. 
# Further infotmation about Salt pillars: http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html
#
# A YAML dictionary of this structure needs to both contain valid data and be available to this file
# dashboard:
#   unix-user-name: dashboard
#   unix-user-home-directory: /home/dashboard


###########################
# General Server set-up #
###########################

include:
  - .IATI-Registry-Refresher.deploy-IATI-Registry-Refresher
  - .IATI-Stats.deploy-IATI-Stats
  - .IATI-Dashboard.deploy-IATI-Dashboard

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
    - user: {{ pillar['dashboard']['unix-user-name'] }}

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
git config --global user.email "code@iatistandard.org":
  cmd.run:
    - user: {{ pillar['dashboard']['unix-user-name'] }}

# Server
/usr/bin/gist:
  file.symlink:
    - target: /usr/bin/gist-paste

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
/home/dashboard/.netrc:
  file.managed:
    - source: salt://iati/dashboard-netrc
    - user: {{ pillar['dashboard']['unix-user-name'] }}
    - template: jinja

# Server - for https://github.com/idsdata/IATI-Urls-Snapshot
https://github.com/idsdata/IATI-Urls-Snapshot.git:
  git.latest:
    - rev: master
    - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Registry-Refresher/urls
    - user: {{ pillar['dashboard']['unix-user-name'] }}


##############
# IATI-Stats #
##############



##################
# IATI-Dashboard #
##################



# Server
{{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/data:
  file.symlink:
    - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Registry-Refresher/data
    - user: {{ pillar['dashboard']['unix-user-name'] }}

# Server
{{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/helpers/ckan:
  file.symlink:
    - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Registry-Refresher/data/IATI-Registry-Refresher/ckan
    - user: {{ pillar['dashboard']['unix-user-name'] }}

# Server
{{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/helpers/rulesets:
    file.symlink:
        - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/IATI-Rulesets/rulesets

# Server - Set-up link between the IATI-Stats output and the data that the IATI-Dashboard looks for to generate the stats
{{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Dashboard/stats-calculated:
    file.symlink:
        - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/gitout

# Server
{{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Dashboard/stats-blacklist:
    file.symlink:
        - target: {{ pillar['dashboard']['unix-user-home-directory'] }}/IATI-Stats/stats-blacklist

# Server - Install dependencies for running the Dashboard on a public webserver
webserver-deps:
    pkg.installed:
        - pkgs:
            - apache2

# Server - Configure the apache public webserver
/etc/apache2/sites-available/new.dashboard.conf:
  file.managed:
    - source: salt://iati/IATI-Dashboard/dashboard-apache

# Server - Set-up a symlink between sites-enabled and sites-available directories
/etc/apache2/sites-enabled/new.dashboard.conf:
    file.symlink:
        - target: /etc/apache2/sites-available/new.dashboard.conf

# Server - Restart apache server if the configuration file changes
apache2:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/sites-available/new.dashboard.conf


# Set the process to run nightly
################################

# Server - Install the script to generate the stats and Dashboard
{{ pillar['dashboard']['unix-user-home-directory'] }}/full-dashboard-run.sh:
  file.managed:
    - source: salt://iati/full-dashboard-run.sh
    - user: {{ pillar['dashboard']['unix-user-name'] }}
    - mode: 755

# Server - Set-up logging directories
{{ pillar['dashboard']['unix-user-home-directory'] }}/logs:
  file.directory:
    - makedirs: True
    - user: {{ pillar['dashboard']['unix-user-name'] }}
    - group: {{ pillar['dashboard']['unix-user-name'] }}

# Server - Set-up cron jobs to run the stats & dashboard generation every night
{{ pillar['dashboard']['unix-user-home-directory'] }}/full-dashboard-run.sh > {{ pillar['dashboard']['unix-user-home-directory'] }}/logs/$(date +\%Y\%m\%d).log 2>&1:
  cron.present:
    - user: {{ pillar['dashboard']['unix-user-name'] }}
    - minute: 1
{% if pillar['env'] == 'dev' %}
    - hour: 6
{% else %}
    - hour: 0
{% endif %}

# Server
{% if pillar['env'] == 'live' %}
curl "http://iatiregistry.org/api/1/search/dataset?isopen=false&limit=200" | grep -o '"[^"]*"' | sed -e 's/"//g' -e 's/-.*//' | sort | uniq -c | gist -u 24beac7d23282f9b15f4 -f license_not_open:
  cron.present:
    - identifier: license-not-open-gist
    - user: {{ pillar['dashboard']['unix-user-name'] }}
    - minute: 0
    - hour: 0
{% endif %}

