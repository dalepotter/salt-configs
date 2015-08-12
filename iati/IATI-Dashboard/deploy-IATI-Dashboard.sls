# The UNIX directory name and the path to that users home directory will need to be set in the Salt pillar.
# Further infotmation about Salt pillars: http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html
#
# A YAML dictionary of this structure needs to both contain valid data and be available to this file
# dashboard:
#   unix-user-name: dashboard
#   unix-user-home-directory: /home/dashboard

# Clone git repo
https://github.com/IATI/IATI-Dashboard.git:
  git.latest:
{% if pillar['env'] == 'dev' %}
    - rev: master
{% else %}
    - rev: live 
{% endif %}
    - target: {{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Dashboard
    - user: {{ pillar['registry-refresher']['unix-user-name'] }}

# Install dependencies
dashboard-deps:
    pkg.installed:
        - pkgs:
            - libfreetype6-dev
            - libpng12-dev
            - pkg-config

# Set-up a virtual environment
{{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Dashboard/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: {{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Dashboard/requirements.txt
        - require:
            - pkg: stats-deps
            - pkg: dashboard-deps

# Set-up jinja templating configutation file
{{ pillar['registry-refresher']['unix-user-home-directory'] }}/IATI-Dashboard/config.py:
    file.managed:
        - source: salt://iati/IATI-Dashboard/dashboard-config.py
        - user: dashboard
        - template: jinja

