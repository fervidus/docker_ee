#!/bin/sh

# Puppet Task Name: inspect_self
#
# @Usage
# Run this task on any node to output scheduler settings.
#
docker node inspect self | grep -i orchestrator | tr -s [:space:]
