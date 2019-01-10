#!/bin/sh

# Puppet Task Name: inspect_scheduler
#
# @Usage
# Run this task on any node to output scheduler settings.
#
echo 'scheduler settings for node: '$PT_node
docker node inspect $PT_node | grep -i orchestrator | tr -s [:space:]
