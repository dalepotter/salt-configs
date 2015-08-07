sshkeys:
  ssh_auth.present:
    - user: root
    - source: salt://iati/ssh-keys.pub
