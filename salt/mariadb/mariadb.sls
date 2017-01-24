include:
  - mariadb.pkg
mariadb-conf-file:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mariadb/files/my.cnf
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: mysql_install_db --user=mysql && sleep 10s && touch  /var/log/mysqld.log && chown -R mysql.mysql /var/log/mysqld.log && touch /etc/maridb-init.lock
    - unless: test -f /etc/maridb-init.lock
  service.running:
    - name: mariadb
    - enable: True
    - watch:
      - file: mariadb-conf-file
   
