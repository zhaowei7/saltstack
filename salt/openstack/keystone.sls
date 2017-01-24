keystone-install:
  pkg.installed:
    - names:
      - python-openstackclient 
      - openstack-selinux
      - openstack-keystone
      - httpd
      - mod_wsgi
keystone-conf:
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/files/keystone.conf
    - user: root
    - group: keystone
    - mode: 755
    - template: jinja
    - defaults:
      mysql_ip: {{ pillar['env-ip']['mysql_ip'] }}
      memcached_ip: {{ pillar['env-ip']['memcached_ip'] }}
      keystone_mysql_pw: {{ pillar['env-passwd']['KEYSTONE_MYSQL_PW'] }} 
keystone-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone && sleep 3s && keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone && touch /etc/keystone-db.lock
    - unless: test -f /etc/keystone-db.lock

keystone-http-conf:
  file.managed:
    - name: /etc/httpd/conf.d/wsgi-keystone.conf 
    - source: salt://openstack/files/wsgi-keystone.conf 
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - watch:
      - file: keystone-http-conf
  require:
    - pkg: keystone-install
create-keystone-service:
  file.managed:
    - name: /root/keystone_init.sh
    - source: salt://openstack/files/keystone_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      admin_pw: {{ pillar['env-passwd']['KEYSTONE_ADMIN_PW'] }}
      demo_pw: {{ pillar['env-passwd']['KEYSTONE_DEMO_PW'] }}
  cmd.run:
    - name: sleep 3 && sh /root/keystone_init.sh && touch /etc/keystone-init.lock
    - unless: test -f /etc/keystone-init.lock

admin-openrc-env:
  file.managed:
    - name: /root/admin-openrc.sh
    - source: salt://openstack/files/admin-openrc.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      admin_pw: {{ pillar['env-passwd']['KEYSTONE_ADMIN_PW'] }}
demo-openrc-env:
  file.managed:
    - name: /root/demo-openrc.sh
    - source: salt://openstack/files/demo-openrc.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      demo_pw: {{ pillar['env-passwd']['KEYSTONE_DEMO_PW'] }}       
remove-admin-token-auth:
  file.managed:
    - name: /etc/keystone/keystone-paste.ini
    - source: salt://openstack/files/keystone-paste.ini
    - mode: 755
    - user: root
    - group: keystone
