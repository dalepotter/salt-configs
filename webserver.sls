#webserver_stuff:
#  pkg:
#    - installed
#    - pkgs:
#      - apache2
#      - php5
#      - mysql-server
#      - php5-mysql
#      - libapache2-mod-auth-mysql

#apache2:
#  service:
#    - running
#    - require:
#      - pkg: webserver_stuff

#mysql:
#  service:
#    - running
#    - require:
#      - pkg: webserver_stuff

include:
  - php5
  - apache
  - mysql
