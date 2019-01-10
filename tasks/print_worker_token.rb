#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task Name: print_worker_token
#
# @Usage
# You MUST run this task on a UCP manager node.
# Outputs the token need to join the UCP as a worker.
#
puts `docker swarm join-token -q worker`
