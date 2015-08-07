# The UNIX directory name and the path to that users home directory will need to be set in the Salt pillar.
# Further infotmation about Salt pillars: http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html
#
# A YAML dictionary of this structure needs to both contain valid data and be available to this file
# stats:
#   unix-user-name: stats
#   unix-user-home-directory: /home/stats

# Install depenencies
stats-deps:
    pkg.installed:
        - pkgs:
            - python-pip
            - python-virtualenv
            - python-dev
            - libxml2-dev
            - libxslt1-dev
            - zlib1g-dev

# Download the Git repository
# Branch name should probably be controlled by a grain
https://github.com/IATI/IATI-Stats.git:
  git.latest:
{% if saltenv == 'dev' %}
    - rev: master
{% else %}
    - rev: live
{% endif %}
    - target: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats
    - user: {{ pillar['dashboard']['unix-user-name'] }}

# Set-up a vitrual environment
{{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/requirements.txt
        - require:
            - pkg: stats-deps
