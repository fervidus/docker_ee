#!/bin/sh

# Puppet Task Name: list_nodes
#
# @Usage
# Run only on UCP managers.
#
# docker node list | tr -s ' ' '|'
docker node list
