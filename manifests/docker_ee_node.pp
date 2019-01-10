# docker_ee_node.pp
# Configures a Docker Universal Control Plane (UCP) VM host.
#
# Run...
# docker swarm join-token manager
# ...on cluster manager to get token for other manager nodes.
#
# A controller node contains the control plane and etcd.
# In a production cluster, you should have three, five, or seven controllers.
# One controller is fine in development.
# Use 1, 3, 5, 7 because the 'etcd' service prerequisite states,
# "Run etcd as a cluster of odd members."
# @source https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/
#
# Use the docker_ee Puppet Tasks to retrieve tokens and join clusters.
#
class docker_ee::docker_ee_node (
  Stdlib::Httpurl $docker_ee_url,
  Stdlib::Httpurl $docker_ee_key_source,
  String          $docker_image = 'docker/ucp:3.1.0',
) {
  # docker image pull docker/ucp:3.1.0
  docker::image { $docker_image: }

  class { '::docker':
    docker_ee                 => true,
    docker_ee_source_location => $docker_ee_url,
    docker_ee_key_source      => $docker_ee_key_source,
  }

  class { '::harden_docker':
    restrict_network_traffic_between_containers => false,
    disable_userland_proxy                      => false,
    enable_live_restore                         => false,
  }
}
