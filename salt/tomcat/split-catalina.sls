/etc/custome-logrotate.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
tomcat-logrotate:
  file.managed:
    - name: /etc/custome-logrotate.d/tomcat
    - source: salt://tomcat/files/tomcat
    - user: tomcat
    - group: tomcat
    - mode: 755
  cron.present:
    - name: /usr/sbin/logrotate -f /etc/custome-logrotate.d/tomcat
    - user: tomcat
    - minute: 59
    - hour: 23
    - require:
      - file: tomcat-logrotate
    - unless: cat /var/spool/cron/tomcat|grep "custome-logrotate.d"
