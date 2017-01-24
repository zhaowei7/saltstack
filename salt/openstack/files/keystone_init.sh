#!/bin/bash
#create keystone user,service,endpoint
export OS_TOKEN=134a375868682f3e2b7c
export OS_URL=http://{{ keystone_ip }}:35357/v3
export OS_IDENTITY_API_VERSION=3
#endpoint service
openstack service create --name keystone --description "OpenStack Identity" identity
sleep 3s
openstack endpoint create --region RegionOne identity public http://{{ keystone_ip }}:5000/v3
sleep 3s
openstack endpoint create --region RegionOne identity internal http://{{ keystone_ip }}:5000/v3
sleep 3s
openstack endpoint create --region RegionOne identity admin http://{{ keystone_ip }}:35357/v3
#create domain default
openstack domain create --description "Default Domain" default
sleep 3s
openstack project create --domain default --description "Admin Project" admin
sleep 3s
openstack user create --domain default  --password={{ admin_pw }} admin
sleep 3s
openstack role create admin
sleep 3s
openstack role add --project admin --user admin admin
sleep 3s
openstack project create --domain default --description "Service Project" service
sleep 3s
#create deom
openstack project create --domain default --description "demo Poroject" demo
sleep 3s
openstack user create --domain default  --password={{ demo_pw }}  demo
sleep 3s
openstack role create user
sleep 3s
openstack role add --project demo --user demo user
