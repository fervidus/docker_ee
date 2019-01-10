#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task Name: print_manager_token
#
# @Usage
# You MUST run this task on a UCP manager node.
# Outputs the token need to join the UCP as a manager.
#
puts `docker swarm join-token -q manager`
