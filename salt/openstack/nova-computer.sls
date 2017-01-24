nova-computer-rpm-install:
  pkg.installed:
    - names:
      - openstack-nova-compute
      - net-tools
      - wget
      - sysfsutils
      - libvirt 
sync-nova-computer-api-conf:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://openstack/files/nova-computer.conf
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
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - watch:
      - file: sync-nova-computer-api-conf
start-libvirtd-service:
  service.running:
    - name: libvirtd
    - enable: True
