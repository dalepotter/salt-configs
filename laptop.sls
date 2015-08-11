# For configuting Dale's Ubuntu laptop with a set of software packages.
# To run:
# 1) Run 'sudo apt-get install salt-minion'
# 2) Change the '/etc/salt/minion' config file to: 'master: <IP Address of Master>'
# 3) Run 'sudo service salt-minion restart'
# 4) Run 'state.sls laptop' on the master
# N.B. May take some time to run


include:
  - basic
  - chromium
  - git
  - atom
  - sublime
  - lamp
  - gmusicbrowser
  - vlc
  - skype
