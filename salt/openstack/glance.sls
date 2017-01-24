glance-install:
  pkg.installed:
    - names:
      - openstack-glance
      - python-glance
create-glance-service:
  file.managed:
    - name: /root/glance_init.sh
    - source: salt://openstack/files/glance_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      glance_ip: {{ pillar['env-ip']['glance_ip'] }}
      glance_pw:  {{ pillar['env-passwd']['GLANCE_PW'] }}
  cmd.run:
    - name: sleep 3 && sh /root/glance_init.sh && touch /etc/glance-init.lock
    - unless: test -f /etc/glance-init.lock
sync-glance-api-conf:
  file.managed:
    - name: /etc/glance/glance-api.conf 
    - source: salt://openstack/files/glance-api.conf 
    - user: root
    - group: glance
    - mode: 755
    - template: jinja
    - defaults:
      mysql_ip: {{ pillar['env-ip']['mysql_ip'] }}
      memcached_ip: {{ pillar['env-ip']['memcached_ip'] }}
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      glance_pw:  {{ pillar['env-passwd']['GLANCE_PW'] }}
      glance_mysql_pw: {{ pillar['env-passwd']['GLANCE_MYSQL_PW'] }}
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance && touch /etc/glance-db.lock
    - unless: test -f /etc/glance-db.lock
  service.running:
    - name: openstack-glance-api
    - enable: True
    - watch:
      - file: sync-glance-api-conf
sync-glance-registry-conf:
  file.managed:
    - name: /etc/glance/glance-registry.conf
    - source: salt://openstack/files/glance-registry.conf
    - user: root
    - group: glance
    - mode: 755
    - template: jinja
    - defaults:
      mysql_ip: {{ pillar['env-ip']['mysql_ip'] }}
      memcached_ip: {{ pillar['env-ip']['memcached_ip'] }}
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      glance_pw:  {{ pillar['env-passwd']['GLANCE_PW'] }}
      glance_mysql_pw: {{ pillar['env-passwd']['GLANCE_MYSQL_PW'] }}
  service.running:
    - name: openstack-glance-registry
    - enable: True
    - watch:
      - file: sync-glance-registry-conf
