# docker_ucp_nfs_server.pp
#
# Create dual role node:  nfs-server & docker-worker
#
# The nfs-client CLI command to test mounting...
# $ showmount -e <nfs-server-hostname-or-ip>

# NOTE:
# I was using exported resources but not now.
# Keep note below in case it is implemented again.
# Old version (before moving to a single shared directory) used
# exported File and File_line resources
# to add nfs sub-directories (e.g. /exports/<sub-dir>) and
# edit the /etc/exports file to change nfs permissions.
#
class docker_ee::docker_ucp_nfs_server (
  Stdlib::Httpurl $docker_ee_url,
  Stdlib::Httpurl $docker_ee_key_source,
  Array           $nfs_server_mount_parents,
  String          $nfs_server_mount_root,
  String          $nfs_server_mount,
  String          $docker_image = 'docker/ucp:3.1.0',
) {

  package { 'nfs-utils':
    ensure   => present,
  }

  file { $nfs_server_mount_parents:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { $nfs_server_mount:
    ensure => directory,
    owner  => nobody,
    group  => nobody,
    mode   => '0777',
  }

  # Is portmap replaced by 'nfs-idmapd.service'?
  # Didn't need portmap (using CentOS 7),
  # it wasn't even installed.
  # So, it's commented out...

  # # /etc/init.d/portmap start
  # service { 'portmap':
  #   ensure => running,
  #   enable => true,
  # }

  file_line { '/etc/exports - nfs root':
    ensure => present,
    path   => '/etc/exports',
    line   => "${nfs_server_mount_root} *(rw,fsid=0)",
    notify => Service['nfs'],
  }

  file_line { '/etc/exports - add domain to share config':
    ensure => present,
    path   => '/etc/exports',
    line   => "${nfs_server_mount} *.${::domain}(rw,sync,no_root_squash)",
    notify => Service['nfs'],
  }

  # /etc/init.d/nfs start
  service { 'nfs':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    restart    => 'systemctl restart nfs',
  }

  #
  # make nfs node a docker worker node as well as a host for nfs...

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
  -> Class['::harden_docker']
}
