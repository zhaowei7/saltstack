# 生产SALT自动化安装
|-- chrony
|   |-- files
|   |   |-- chrony-client.conf
|   |   `-- chrony-server.conf
|   |-- ntp-client.sls
|   `-- ntp-server.sls
|-- mariadb
|   |-- files
|   |   `-- my.cnf
|   |-- mariadb.sls
|   `-- pkg.sls
|-- nginx
|   |-- files
|   |   |-- nginx
|   |   |-- nginx1.9.9
|   |   |-- nginx.conf
|   |   |-- nginx_cut.sh
|   |   |-- nginx.sysconf
|   |   `-- php_info.conf
|   |-- nginx-install.sls
|   |-- pkg.sls
|   `-- soft
|       |-- nginx-1.10.2.tar.gz
|       `-- nginx-1.9.9.tar.gz
|-- openstack
|   |-- computer.sls
|   |-- controller.sls
|   |-- create_db.sls
|   |-- dashboard.sls
|   |-- files
|   |   |-- admin-openrc.sh
|   |   |-- demo-openrc.sh
|   |   |-- dhcp_agent_controller.ini
|   |   |-- glance-api.conf
|   |   |-- glance_init.sh
|   |   |-- glance-registry.conf
|   |   |-- keystone.conf
|   |   |-- keystone_init.sh
|   |   |-- keystone-paste.ini
|   |   |-- linuxbridge_agent_computer.ini
|   |   |-- linuxbridge_agent_controller.ini
|   |   |-- local_settings
|   |   |-- metadata_agent_controller.ini
|   |   |-- ml2_conf_computer.ini
|   |   |-- ml2_conf_controller.ini
|   |   |-- neutron_computer.conf
|   |   |-- neutron_controller.conf
|   |   |-- neutron_init.sh
|   |   |-- neutron_net_create.sh
|   |   |-- nova-computer.conf
|   |   |-- nova-controller.conf
|   |   |-- nova_init.sh
|   |   `-- wsgi-keystone.conf
|   |-- glance.sls
|   |-- keystone.sls
|   |-- memcached.sls
|   |-- neutron-computer.sls
|   |-- neutron.sls
|   |-- nova-computer.sls
|   |-- nova.sls
|   `-- README.md
|-- php56
|   |-- files
|   |   |-- init.d.php-fpm
|   |   |-- memcache-2.2.7.tgz
|   |   |-- php-5.6.29.tar.gz
|   |   |-- php-5.6.9.tar.gz
|   |   |-- php-fpm.conf.default
|   |   |-- php.ini-production
|   |   `-- redis-2.2.7.tgz
|   |-- php-install.sls
|   |-- php-memcache.sls
|   `-- php-redis.sls
|-- rabbitmq
|   |-- files
|   |   `-- rabbitmq.config
|   `-- rabbitmq.sls
|-- redis
|   |-- files
|   |   |-- keepalived.init
|   |   |-- keepalived.sysconfig
|   |   |-- master-keepalived.conf
|   |   |-- master-redis.conf
|   |   |-- redis2.8_init_script
|   |   |-- redis_backup.sh
|   |   |-- redis_check.sh
|   |   |-- redis_fault.sh
|   |   |-- redis_master.sh
|   |   |-- redis_stop.sh
|   |   |-- slave-keepalived.conf
|   |   |-- slave-redis.conf
|   |   `-- sysctl.conf
|   |-- keepalived-install.sls
|   |-- pkg.sls
|   |-- redis-install.sls
|   `-- soft
|       |-- keepalived-1.2.20.tar.gz
|       `-- redis-2.8.24.tar.gz
`-- tomcat
    |-- files
    |   |-- catalina.sh
    |   |-- server.xml
    |   |-- tomcat
    |   `-- web.xml
    |-- soft
    |   `-- apache-tomcat-7.0.70.tar.gz
    |-- split-catalina.sls
    `-- tomcat-install.sls
