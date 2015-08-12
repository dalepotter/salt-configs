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
{% if pillar['env'] == 'dev' %}
    - rev: master
{% else %}
    - rev: live
{% endif %}
    - target: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats
    - user: {{ pillar['stats']['unix-user-name'] }}

# Set-up a vitrual environment
{{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/pyenv/:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/requirements.txt
        - no_chown: True
        - require:
            - pkg: stats-deps

# Ensure the stats helpers are set-up: IATI Schemas
{{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/get_schemas.sh:
    cmd.run:
        - cwd: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/

# Ensure the stats helpers are set-up: IATI Codelist Mapping
{{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/get_codelist_mapping.sh:
    cmd.run:
        - cwd: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/

# Ensure the stats helpers are set-up: Codelists
{{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/get_codelists.sh:
    cmd.run:
        - cwd: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/helpers/

# Ensure the stats helpers are set-up: IATI Rulesets
https://github.com/IATI/IATI-Rulesets.git:
    git.latest:
        - rev: version-1.05
        - target: {{ pillar['stats']['unix-user-home-directory'] }}/IATI-Stats/IATI-Rulesets/
        - user: {{ pillar['stats']['unix-user-name'] }}

