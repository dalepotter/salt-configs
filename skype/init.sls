skype: 
  cmd.run:
    - name: |
      dpkg --add-architecture i386
      add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
      apt-get update && apt-get install skype pulseaudio:i386
    - unless: dpkg -s skype  
