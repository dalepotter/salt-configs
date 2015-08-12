# @todo This file to be the top.sls file when IATI has it's own salt repo
# For now, it can be run using: salt '*' state.top iati/iati.sls

base:
  '*':
    - iati.basic

  'IATI-Dummy2':
    - iati.deploy-server-IATI-Dashboard
