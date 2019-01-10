#!/bin/sh

# Puppet Task Name: assign_node
#
docker swarm join --token $PT_join_token $PT_ucp_addr:2377
