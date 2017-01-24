neutron-install:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-linuxbridge
      - ebtables
      - ipset
create-neutron-service:
  file.managed:
    - name: /root/neutron_init.sh
    - source: salt://openstack/files/neutron_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      neutron_ip: {{ pillar['env-ip']['neutron_ip'] }}
      neutron_pw:  {{ pillar['env-passwd']['NEUTRON_PW'] }}
  cmd.run:
    - name: sleep 3 && sh /root/neutron_init.sh && touch /etc/neutron-init.lock
    - unless: test -f /etc/netron-init.lock
sync-netron-metadata-conf:
  file.managed:
    - name: /etc/neutron/metadata_agent.ini
    - source: salt://openstack/files/metadata_agent_controller.ini
    - user: root
    - group: neutron
    - mode: 755
    - template: jinja
    - defaults:
      nova_ip: {{ pillar['env-ip']['nova_ip'] }}
      keystone_ip: {{ pillar['env-ip']['keystone_ip'] }}
      neutron_ip: {{ pillar['env-ip']['neutron_ip'] }}
      neutron_pw:  {{ pillar['env-passwd']['NEUTRON_PW'] }}
sync-netron-ml2-conf:
  file.managed:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - source: salt://openstack/files/ml2_conf_controller.ini
    - user: root
    - group: neutron
    - mode: 755
  cmd.run:
    - name: ln -sfn /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
    - unless: test -L /etc/neutron/plugin.ini
sync-netron-linuxbridge-conf:
  file.managed:
    - name: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
    - source: salt://openstack/files/linuxbridge_agent_controller.ini
    - user: root
    - group: neutron
    - mode: 755
sync-netron-dhcp-agent-conf:
  file.managed:
    - name: /etc/neutron/dhcp_agent.ini
    - source: salt://openstack/files/dhcp_agent_controller.ini
    - user: root
    - group: neutron
    - mode: 755
sync-neutron-conf:
  file.managed:
    - name: /etc/neutron/neutron.conf
    - source: salt://openstack/files/neutron_controller.conf
    - user: root
    - group: neutron
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
      neutron_mysql_pw: {{ pillar['env-passwd']['NEUTRON_MYSQL_PW'] }}
  cmd.run:
    - name: su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron && touch /etc/neutron-db.lock && systemctl restart openstack-nova-api
    - unless: test -f /etc/neutron-db.lock
neutron-server:
  service.running:
    - enable: True
    - watch:
      - file: sync-neutron-conf
neutron-linuxbridge-agent:
  service.running:
    - enable: True
    - watch:
      - file: sync-netron-linuxbridge-conf
neutron-dhcp-agent:
  service.running:
    - enable: True
    - watch:
      - file: sync-netron-dhcp-agent-conf
neutron-metadata-agent:
  service.running:
    - enable: True
    - watch:
      - file: sync-netron-metadata-conf
create-neutron-subnet:
  file.managed:
    - name: /root/neutron_net_create.sh
    - source: salt://openstack/files/neutron_net_create.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: sh /root/neutron_net_create.sh && touch /etc/neutron_net_create.lock
    - unless: test -f /etc/neutron_net_create.lock
