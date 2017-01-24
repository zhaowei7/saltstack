dashboard-rpm-install:
  pkg.installed:
    - names:
      - openstack-dashboard
  file.managed:
    - name: /etc/openstack-dashboard/local_settings
    - source: salt://openstack/files/local_settings
    - user: root
    - group: apache
    - mode: 755
    - template: jinja
    - defaults:
      memcached_ip: {{ pillar['env-ip']['memcached_ip'] }}
      dashboard_ip: {{ pillar['env-ip']['dashboard_ip'] }}
  service.running:
    - name: httpd
    - enable: True
    - reload: True
  cmd.run:
    - name: systemctl restart httpd.service memcached.service
