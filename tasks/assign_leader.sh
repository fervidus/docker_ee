#!/bin/sh

# Puppet Task Name: assign_leader
#
my_fqdn=`hostname -f`
my_ip=`facter ipaddress`
docker container run --rm --name ucp-leader -v /var/run/docker.sock:/var/run/docker.sock $PT_docker_image install --force-minimums --host-address $my_ip --san $my_fqdn --san $PT_ucp_load_balancer --pod-cidr $PT_pod_cidr --admin-username $PT_ucp_admin_username --admin-password $PT_ucp_admin_password
