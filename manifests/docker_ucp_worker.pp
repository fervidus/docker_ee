# docker_ucp_worker.pp
# Configure nfs for a Docker worker node VM host.
#
# To join Docker Universal Control Plane v2 via CLI...
# docker swarm join-token -q worker
# docker swarm join --token SWMTKN-1-5rwojlxfp03s4cz9jkfz672e3trkglp01atql75kfnky6timch-8xnqk36zsaxa2d11b35vopdof 192.168.5.28:2377
#
# Use the docker_ucp Puppet Tasks to retrieve tokens and join clusters.
#
class docker_ee::docker_ucp_worker (
  Stdlib::Httpurl $docker_ee_url,
  Stdlib::Httpurl $docker_ee_key_source,
  Array           $nfs_client_mount_parents,
  String          $nfs_client_mount,
  String          $nfs_host,
  String          $nfs_server_mount,
  String          $docker_image = 'docker/ucp:3.1.0',
) {
  # class { '::docker_ee::docker_ucp_mount_nfs':
  #   nfs_client_mount_parents => $nfs_client_mount_parents,
  #   nfs_client_mount         => $nfs_client_mount,
  #   nfs_host                 => $nfs_host,
  #   nfs_server_mount         => $nfs_server_mount,
  # }

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

  Class['::docker']
  # -> Class['::docker_ucp::docker_ucp_mount_nfs']
  -> Class['::harden_docker']
}
