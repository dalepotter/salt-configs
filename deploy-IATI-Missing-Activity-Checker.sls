https://github.com/IATI/IATI-Missing-Activity-Checker.git:
  git.latest:
    - rev: master
    - target: /home/missingactivities/

/home/missingactivities/run.sh:
  file.managed:
    - mode: 755

/home/missingactivities/get_data.sh:
  file.managed:
    - mode: 755

/home/missingactivities/logs:
  file.directory:
    - makedirs: True

cd /home/missingactivities/ && ./run.sh > /home/missingactivities/logs/log.log:
  cron.present:
    - identifier: IATI-Missing-Activity-Checker
    - user: root
    - minute: 0
    - hour: 0
