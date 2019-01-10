#!/bin/sh

# Puppet Task Name: enable_kubernetes_scheduler
#
# @Usage
# You MUST run this task on a UCP manager node,
# but the target is set to the node you wish to set.

docker node update --label-rm com.docker.ucp.orchestrator.swarm --label-add com.docker.ucp.orchestrator.kubernetes=true $PT_node
echo 'scheduler settings for node: '$PT_node
docker node inspect $PT_node | grep -i orchestrator | tr -s [:space:]
