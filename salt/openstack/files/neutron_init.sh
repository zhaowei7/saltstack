#!/bin/bash
source /root/admin-openrc.sh
openstack user create --domain default --password={{ neutron_pw }} neutron
sleep 3s
openstack role add --project service --user neutron admin             
sleep 3s
openstack service create --name neutron --description "OpenStack Networking" network
sleep 3s
#endpoint service
openstack endpoint create --region RegionOne network public http://{{ neutron_ip }}:9696
sleep 3s
openstack endpoint create --region RegionOne network internal http://{{ neutron_ip }}:9696
sleep 3s
openstack endpoint create --region RegionOne network admin http://{{ neutron_ip }}:9696
