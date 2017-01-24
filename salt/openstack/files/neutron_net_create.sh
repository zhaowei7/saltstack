#!/bin/bash
source /root/admin-openrc.sh
neutron net-create flat --shared --provider:physical_network physnet1 --provider:network_type flat
sleep 3s
neutron subnet-create flat 192.168.1.0/23 --name flat-subnet --allocation-pool start=192.168.1.230,end=192.168.1.249 --dns-nameserver 223.5.5.5 --dns-nameserver 223.6.6.6 --gateway 192.168.0.1
sleep 3s
source /root/demo-openrc.sh
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
sleep 3s
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

