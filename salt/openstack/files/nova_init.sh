#!/bin/bash
source /root/admin-openrc.sh
openstack user create --domain default --password={{ nova_pw }} nova
sleep 3s
openstack role add --project service --user nova admin             
sleep 3s
openstack service create --name nova --description "OpenStack Compute" compute
sleep 3s
#endpoint service
openstack endpoint create --region RegionOne compute public http://{{ nova_ip }}:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://{{ nova_ip }}:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://{{ nova_ip }}:8774/v2.1/%\(tenant_id\)s
