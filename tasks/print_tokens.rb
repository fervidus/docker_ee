#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task Name: print_tokens
#
# @Usage
# You MUST run this task on a UCP manager node.
# Outputs the tokens needed to join the UCP.
# The 'manager' token comes first,
# followed by the 'worker' token.
#
puts 'manager-token='
puts `docker swarm join-token -q manager`

puts 'worker-token='
puts `docker swarm join-token -q worker`
