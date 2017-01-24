{% set dbs = ['keystone','glance','neutron','nova','nova_api','cinder'] %}
{% set mysql = '/usr/bin/mysql' %}
{% set mysql_pw = '609' %}
{% for db in dbs  %}
{{ db }}:
{% if db == 'nova_api' %}
  cmd.run: 
    - name: {{ mysql }} -uroot  -e "CREATE DATABASE {{ db }};" && {{ mysql }} -uroot  -e "GRANT ALL PRIVILEGES ON {{ db }}.* TO 'nova'@'localhost' IDENTIFIED BY 'nova{{ mysql_pw }}';" && {{ mysql }} -uroot  -e "GRANT ALL PRIVILEGES ON {{ db }}.* TO 'nova'@'192.168.%' IDENTIFIED BY 'nova{{ mysql_pw }}';"
    - unless: test -f /etc/create-db.lock
{% else  %}
  cmd.run:
    - name: {{ mysql }} -uroot  -e "CREATE DATABASE {{ db }};" && {{ mysql }} -uroot  -e "GRANT ALL PRIVILEGES ON {{ db }}.* TO '{{ db }}'@'localhost' IDENTIFIED BY '{{ db }}{{ mysql_pw }}';" && {{ mysql }} -uroot  -e "GRANT ALL PRIVILEGES ON {{ db }}.* TO '{{ db }}'@'192.168.%' IDENTIFIED BY '{{ db }}{{ mysql_pw }}';"
    - unless: test -f /etc/create-db.lock
{% endif %}
{% endfor %}
create-lock:
  cmd.run:
    - name: touch /etc/create-db.lock
    - unless: test -f /etc/create-db.lock
