# 本版本为openstack-Mitaka 
- 配置好每个节点主机名解析，NTP,内部Mitaka的YUM安装源。
- 修改/srv/salt/openstack/mysql.sls,{% set mysql="" %}变量，建立openstack数据库，DB用户及密码。
- 默认MySQL,Memcached,Rabbitmq 安装在控制节点,默认数据库ROOT密码为空,安装在控制节点。
- 修改控制节点IP sed -i 's#192.168.75.132#192.168.1.234#g' /srv/pillar/openstack/env-ip.sls
- 生产建议MYSQL(master-slave)/RabitMQ(cluster-HA)安装独立服务器。
- 修改虚拟机子网 vi neutron_net_create.sh

