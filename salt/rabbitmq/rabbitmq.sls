rpm-install:
  pkg.installed:
    - names:
      - rabbitmq-server 
  file.managed:
    - name: /etc/rabbitmq/rabbitmq.config
    - source: salt://rabbitmq/files/rabbitmq.config
    - user: rabbitmq
    - group: rabbitmq
    - mode: 755
  service.running:
    - name: rabbitmq-server
    - enable: True
  cmd.run:
    - name: rabbitmqctl add_user openstack openstack609 && sleep 2s && rabbitmqctl set_permissions openstack ".*" ".*" ".*" && sleep 2s && rabbitmq-plugins enable rabbitmq_management && sleep 2s && rabbitmqctl change_password guest cloudcc#123 && touch /etc/rabbitmq.lock
    - require:
      - pkg: rpm-install
      - service: rpm-install
    - unless: test -f /etc/rabbitmq.lock
