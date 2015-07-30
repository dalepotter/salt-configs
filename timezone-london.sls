# Set timezone to UK time
Europe/London:
  timezone.system:
    - utc: True

# Restart Cron on timezone change
cron:
  service.running:
    - reload: True
