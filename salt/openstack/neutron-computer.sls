neutron-computer-rpm-install:
  pkg.installed:
    - names:
      - openstack-neutron-linuxbridge
      - ebtables
      - ipset
sync-neutron-computer-api-conf:
  file.managed:
    - name: /etc/neutron/neutron.conf
    - source: salt://openstack/files/neutron_computer.conf
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
  service.running:
    - name: neutron-linuxbridge-agent
    - enable: True
    - watch:
      - file: sync-neutron-computer-api-conf
sync-netron-ml2-computer-conf:
  file.managed:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - source: salt://openstack/files/ml2_conf_computer.ini
    - user: root
    - group: neutron
    - mode: 755
  cmd.run:
    - name: ln -sfn /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
    - unless: test -L /etc/neutron/plugin.ini
sync-netron-linuxbridge-computer-conf:
  file.managed:
    - name: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
    - source: salt://openstack/files/linuxbridge_agent_computer.ini
    - user: root
    - group: neutron
    - mode: 755
  cmd.run:
    - name: systemctl restart openstack-nova-compute
