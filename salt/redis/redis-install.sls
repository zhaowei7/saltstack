include:
  - redis.pkg
{% set version = '2.8.24' %}
{% set port = '6379' %}
redis_user:
  user.present:
    - name: redis
    - uid: 1503
    - gid_from_name: True
    - unless: test -d /home/redis
redis-install:
  file.managed:
    - name: /usr/local/src/redis-{{ version }}.tar.gz
    - source: salt://redis/soft/redis-{{ version }}.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd  /usr/local/src && tar zxf redis-{{ version }}.tar.gz && cd  redis-{{ version }} &&  make && echo never > /sys/kernel/mm/transparent_hugepage/enabled
    - unless: test -d /usr/local/src/redis-{{ version }}
    - require:
      - file: redis-install
copy-redis-conf:
  cmd.run:
    - name: mkdir -p /usr/local/webserver/redis-{{ port }}/bin && mkdir -p /usr/local/webserver/redis-{{ port }}/conf && mkdir -p /usr/local/webserver/redis-{{ port }}/log && mkdir -p /usr/local/webserver/redis-{{ port }}/data && cp /usr/local/src/redis-{{ version }}/src/redis-cli /usr/local/webserver/redis-{{ port }}/bin/ && cp /usr/local/src/redis-{{ version }}/src/redis-server /usr/local/webserver/redis-{{ port }}/bin/ && cp /usr/local/src/redis-{{ version }}/src/redis-check-dump /usr/local/webserver/redis-{{ port }}/bin/ && cp /usr/local/src/redis-{{ version }}/src/redis-check-aof /usr/local/webserver/redis-{{ port }}/bin/ && cp /usr/local/src/redis-{{ version }}/src/redis-benchmark /usr/local/webserver/redis-{{ port }}/bin/ && cp /usr/local/src/redis-{{ version }}/src/redis-sentinel /usr/local/webserver/redis-{{ port }}/bin/ 
    - unless: test -d /usr/local/webserver/redis-{{ port }}
redis-conf:
{% if grains['fqdn'] == 'centos6'  %}
  file.managed:
    - name: /usr/local/webserver/redis-{{ port }}/conf/redis.conf
    - source: salt://redis/files/master-redis.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      MAX_CLIENTS: 100
      MAX_MEMORY: 2G
      PASSWD: 1q2w3e4r
{% elif  grains['fqdn'] == 'centos6.5-salt-3.novalocal' %}
  file.managed:
    - name: /usr/local/webserver/redis-{{ port }}/conf/redis.conf
    - source: salt://redis/files/slave-redis.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      PORT: 6379
      MAX_CLIENTS: 100
      MAX_MEMORY: 2G
      MASTER_IP: 192.168.1.237
      PASSWD: 1q2w3e4r
    {%  endif %}
sysctl-conf:
  file.managed:
    - name: /etc/sysctl.conf
    - source: salt://redis/files/sysctl.conf  
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: /sbin/sysctl -p
