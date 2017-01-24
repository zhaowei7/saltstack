nova-install:
  pkg.installed:
    - names:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
create-nova-service:
  file.managed:
    - name: /root/nova_init.sh
    - source: salt://openstack/files/nova_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      nova_ip: {{ pillar['env-ip']['nova_ip'] }}
      nova_pw:  {{ pillar['env-passwd']['NOVA_PW'] }}
  cmd.run:
    - name: sleep 3 && sh /root/nova_init.sh && touch /etc/nova-init.lock
    - unless: test -f /etc/nova-init.lock
sync-nova-api-conf:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://openstack/files/nova-controller.conf
    - user: root
    - group: nova
    - mode: 755
    - template: jinja
    - defaults:
      mysql_ip: {{ pillar['env-ip']['mysql_ip'] }}
      glance_ip: {{ pillar['env-ip']['glance_ip'] }}
      memcached_ip: {{ pillar['env-ip']['memcached_ip'] }}
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      nova_ip: {{ pillar['env-ip']['nova_ip'] }}
      nova_pw:  {{ pillar['env-passwd']['NOVA_PW'] }}
      neutron_ip: {{ pillar['env-ip']['neutron_ip'] }}
      neutron_pw:  {{ pillar['env-passwd']['NEUTRON_PW'] }}
      rabbitmq_ip: {{ pillar['env-ip']['rabbitmq_ip'] }}
      rabbit_password: {{ pillar['env-passwd']['RABBITMQ_PW'] }}
      my_ip: {{ grains['ip_interfaces']['eth0'][0] }}
      nova_mysql_pw: {{ pillar['env-passwd']['NOVA_MYSQL_PW'] }}
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage api_db sync" nova && sleep 3s && su -s /bin/sh -c "nova-manage db sync" nova  && touch /etc/nova-db.lock
    - unless: test -f /etc/nova-db.lock
openstack-nova-api:
  service.running:
    - enable: True
    - watch:
      - file: sync-nova-api-conf
openstack-nova-consoleauth:
  service.running:
    - enable: True
    - watch:
      - file: sync-nova-api-conf
openstack-nova-scheduler:
  service.running:
    - enable: True
    - watch:
      - file: sync-nova-api-conf
openstack-nova-conductor:
  service.running:
    - enable: True
    - watch:
      - file: sync-nova-api-conf
openstack-nova-novncproxy:
  service.running:
    - enable: True
    - watch:
      - file: sync-nova-api-conf
