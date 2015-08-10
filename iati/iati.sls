# @todo This file to be the top.sls file when IATI has it's own salt repo
# For now, it can be run using: salt '*' state.sls iati.iati

base:
  '*':
    - basic

  'IATI-Dummy2':
    - deploy-server-IATI-Dashboard
