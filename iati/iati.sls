# @todo This file to be the top.sls file when IATI has it's own salt repo

base:
  '*':
    - ssh-keys
  'IATI-Dummy2':
    - deploy-server-IATI-Dashboard
