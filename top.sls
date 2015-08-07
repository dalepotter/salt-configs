base:
  '*':
    - basic
    - git

  'IATI-Dummy,webserver12':
    - match: list
    - deploy-IATI-Missing-Activity-Checker
