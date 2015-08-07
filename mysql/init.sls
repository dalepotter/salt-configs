mysql:
  pkg:
    - installed
    - pkgs:
      - mysql-server
      - php5-mysql
      - libapache2-mod-auth-mysql
  service:
    - running
    - require:
      - pkg: mysql-server

