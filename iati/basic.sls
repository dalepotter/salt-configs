# Set the timezone
Europe/London:
    timezone.system

# Set-up SSH keys for the developers
include:
  - iati.ssh-keys

# Set-up automatic updates
basic-server-deps:
    pkg.installed:
        - pkgs:
            - unattended-upgrades

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - source: salt://iati/50unattended-upgrades

/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - source: salt://iati/10periodic

# Restart Cron on timezone change
cron:
  service.running:
    - reload: True
    - watch:
#      - file: /etc/localtime 
      - cmd: "/etc/localtime"
