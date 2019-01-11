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
  String          $docker_os_version = '7',
) {
  # Stdlib::Httpurl $docker_ee_key_source,
  # String          $docker_image = 'docker/ucp:3.1.0',
  #
  # docker::image { $docker_image: }
  #
  # class { '::docker':
  #   docker_ee                 => true,
  #   docker_ee_source_location => $docker_ee_url,
  #   docker_ee_key_source      => $docker_ee_key_source,
  # }

  # getting dependency errors, consolidating code below

  # class { '::docker_ee::pre_install': }
  # -> class { '::docker_ee::yum_configure': }
  # ~> class { '::docker_ee::yum_memcache': }
  # -> class { '::docker_ee::install': }
  # -> class { '::docker_ee::configure': }
  # ~> class { '::docker_ee::run': }
  # -> class { '::harden_docker': }

  file { 'docker_ee-/var/lib/docker':
    ensure => directory,
    path   => '/var/lib/docker',
  }

  # ::docker_ee::pre_install
  # Put EE repository URL in  /etc/yum/vars/dockerurl
  file { '/etc/yum/vars/dockerurl':
    ensure  => file,
    content => "${::docker_ee::docker_ee_url}/rhel",
  }

  # Put EE repository URL in  /etc/yum/vars/dockerosversion
  file { '/etc/yum/vars/dockerosversion':
    ensure  => file,
    content => $::docker_ee::docker_os_version,
  }

  $docker_ee_remove_packages = [
    'docker',
    'docker-common',
    'docker-engine',
  ]

# possible dependency error...
  # Remove old docker installs
  # $docker_ee_remove_packages.each | Integer $index, String $package_name | {
  #   package { $package_name:
  #     ensure => absent,
  #   }
  # }

  $docker_ee_required_packages = ['yum-utils', 'device-mapper-persistent-data', 'lvm2']

  $docker_ee_required_packages.each | Integer $index, String $package_name | {
    package { $package_name:
      ensure => present,
    }
  }

  # ::docker_ee::yum_configure
  # Refresh memcache
  exec { "/bin/yum-config-manager --add-repo ${::docker_ee::docker_ee_url}/rhel/docker-ee.repo":
    creates  => '/etc/yum.repos.d/docker-ee.repo',
  }

  # ::docker_ee::yum_memcache
  # Refresh memcache
  exec { '/bin/yum makecache fast':
    refreshonly  => true,
  }

  # ::docker_ee::install
  # Put EE repository URL in  /etc/yum/vars/dockerurl
  package { 'docker-ee':
    ensure => installed,
  }

  # ::docker_ee::configure
  $devicemapper_content = @("DEVICEMAPPER"/L)
    {
      "storage-driver": "overlay2"
    }
    | DEVICEMAPPER

  augeas { 'docker_storage_driver':
    lens    => 'Json.lns',
    incl    => '/etc/docker/daemon.json',
    changes => [
      'set dict/entry[.=\'storage-driver\'] storage-driver',
      'set dict/entry[.=\'storage-driver\']/string overlay2',
    ],;
  }

  # ::docker_ee::run
  service { 'docker':
    ensure => running,
    enable => true,
  }

  class { '::harden_docker': }

  # ::yumrepo { '::docker':
  #   ensure => 'absent',
  # }

  # NITC users 'serverbuild' for UID 1000. That conflicts with the 'jenkins' user that the jenkins container tries to use.
  # Probably not a good idea to remove serverbuild. Not sure what it is used for.
  # So that is why we are adding 'serverbuild' to the docker group
  # user { 'serverbuild':
  #   ensure => present,
  #   gid    => 1000,
  #   groups => ['docker'],
  #   shell  => '/bin/bash',
  #   uid    => 1000,
  # }
  #
  # mount { '/var/lib/docker':
  #   ensure  => 'mounted',
  #   device  => '/dev/appVG/appLV',
  #   fstype  => 'xfs',
  #   options => 'defaults',
  #   target  => '/etc/fstab',
  # }
  #
  # class { '::docker':
  #   docker_ee                 => true,
  #   docker_ee_source_location => $docker_ee_url,
  #   docker_ee_key_source      => $docker_ee_key_source,
  # } -> class { '::harden_docker':
  #   restrict_network_traffic_between_containers => false,
  #   disable_userland_proxy                      => false,
  #   enable_live_restore                         => false,
  # }
}
