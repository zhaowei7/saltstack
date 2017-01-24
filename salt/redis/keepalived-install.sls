include:
  - redis.pkg
keepalived-install:
  file.managed:
    - name: /usr/local/src/keepalived-1.2.20.tar.gz
    - source: salt://redis/soft/keepalived-1.2.20.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd  /usr/local/src && tar zxf keepalived-1.2.20.tar.gz && cd  keepalived-1.2.20 && ./configure --prefix=/usr/local/keepalived --disable-fwmark && make && make install
    - unless: test -d /usr/local/keepalived
    - require:
      - file: keepalived-install
/etc/keepalived:
  file.directory:
    - user: root
    - group: root
    - mode: 755
keepalived-sysconf-file:
  file.managed:
    - name: /etc/sysconfig/keepalived
    - source: salt://redis/files/keepalived.sysconfig
    - mode: 644
    - user: root
    - group: root
keepalived-start-script:
  file.managed:
    - name: /etc/init.d/keepalived
    - source: salt://redis/files/keepalived.init
    - mode: 755
    - user: root
    - group: root
keepalived-sbin-conf:
  cmd.run:
    - name: cp -rfa  /usr/local/keepalived/sbin/keepalived  /usr/sbin/ 
    - unless: test -f /usr/sbin/keepalived
    - require:
      - file: keepalived-install
add-keepalivd-service:
  cmd.run:
    - name: chkconfig --add keepalived
    - unless: chkconfig --list|grep keepalived
    - require:
      - file: keepalived-start-script
keepalived-conf:
{% if grains['fqdn'] == 'centos6'  %}
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://redis/files/master-keepalived.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      VIP: 192.168.1.234
      ROUTEID: redis_ha
      STATEID: BACKUP
      PRIORITYID: 150
{% elif  grains['fqdn'] == 'centos6.5-salt-3.novalocal' %}
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://redis/files/slave-keepalived.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      VIP: 192.168.1.234
      ROUTEID: redis_ha
      STATEID: BACKUP
      PRIORITYID: 100
    {%  endif %}
  service.running:
    - name: keepalived
    - enable: Ture
    - watch:
      - file: keepalived-conf
redis-check:
  file.managed:
    - name: /etc/keepalived/redis_check.sh
    - source: salt://redis/files/redis_check.sh
    - mode: 755
    - user: root
    - group: root   
    - template: jinja
    - defaults:
      PORT: 6379
      PASSWD: 1q2w3e4r
redis-backup:
  file.managed:
    - name: /etc/keepalived/redis_backup.sh
    - source: salt://redis/files/redis_backup.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      PASSWD: 1q2w3e4r
      MASTER_IP: 192.168.1.239
redis-master:
  file.managed:
    - name: /etc/keepalived/redis_master.sh
    - source: salt://redis/files/redis_master.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      PASSWD: 1q2w3e4r
redis-stop.sh:
  file.managed:
    - name: /etc/keepalived/redis_stop.sh
    - source: salt://redis/files/redis_stop.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      PASSWD: 1q2w3e4r
redis-fault:
  file.managed:
    - name: /etc/keepalived/redis_fault.sh
    - source: salt://redis/files/redis_fault.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      PASSWD: 1q2w3e4r
