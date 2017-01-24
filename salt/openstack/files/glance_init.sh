#!/bin/bash
source /root/admin-openrc.sh
openstack user create --domain default --password={{ glance_pw }} glance
sleep 3s
openstack role add --project service --user glance admin                      
sleep 3s
openstack service create --name glance --description "OpenStack Image" image   
sleep 3s
#endpoint service
openstack endpoint create --region RegionOne image public http://{{ glance_ip }}:9292
openstack endpoint create --region RegionOne image internal http://{{ glance_ip }}:9292
openstack endpoint create --region RegionOne image admin http://{{ glance_ip }}:9292
