# docker_ce_node.pp
# Configures a Docker CE (Community Edition) VM host.
#
class docker_ee::docker_ce_node {

  file { 'docker_ce_node-file-resource-/var/lib/docker':
    ensure => directory,
    path   => '/var/lib/docker',
  }

  # ::docker_ee::pre_install
  # Put EE repository URL in  /etc/yum/vars/dockerurl
  # file { '/etc/yum/vars/dockerurl':
  #   ensure  => file,
  #   content => "${docker_ee_url}/centos",
  # }

  # Put EE repository URL in  /etc/yum/vars/dockerosversion
  # file { '/etc/yum/vars/dockerosversion':
  #   ensure  => file,
  #   content => $docker_os_version,
  # }

  # $docker_ee_remove_packages = [
  #   'docker',
  #   'docker-common',
  #   'docker-engine',
  # ]

# possible dependency error...
  # Remove old docker installs
  # $docker_ee_remove_packages.each | Integer $index, String $package_name | {
  #   package { $package_name:
  #     ensure => absent,
  #   }
  # }

  # $docker_ee_required_packages = ['yum-utils', 'device-mapper-persistent-data', 'lvm2']

  # $docker_ee_required_packages.each | Integer $index, String $package_name | {
  #   package { $package_name:
  #     ensure => present,
  #   }
  # }

  # ::docker_ee::yum_configure
  # Refresh memcache
  # exec { "/bin/yum-config-manager --add-repo ${::docker_ee::docker_ee_url}/centos/docker-ee.repo":
  #   creates  => '/etc/yum.repos.d/docker-ee.repo',
  # }
  # https://storebits.docker.com/ee/centos/sub-f67755a1-fc8d-4177-ba96-4c2a6dd58f64/
  # exec { '/bin/yum-config-manager --add-repo https://storebits.docker.com/ee/centos/sub-f67755a1-fc8d-4177-ba96-4c2a6dd58f64/centos/docker-ee.repo':
  #   creates  => '/etc/yum.repos.d/docker-ee.repo',
  # }

  # ::docker_ee::yum_memcache
  # Refresh memcache
  # exec { '/bin/yum makecache fast':
  #   refreshonly  => true,
  # }

  # ::docker_ee::install
  # Put EE repository URL in  /etc/yum/vars/dockerurl
  # package { 'docker':
  #   ensure => installed,
  # }
  package { 'docker':
    ensure => installed,
  }
  # This package statement seems unnecessary
  # Got the error below before it was commented out...
  # Error: Execution of '/usr/bin/yum -d 0 -e 0 -y install docker-ee' returned 1: Error: Nothing to do
  # Error: /Stage[main]/Docker_ee::Docker_ee_node/Package[docker-ee]/ensure: change from 'purged' to 'present' failed: Execution of '/usr/bin/yum -d 0 -e 0 -y install docker-ee' returned 1: Error: Nothing to do #lint:ignore:140chars


  # ::docker_ee::run
  service { 'docker':
    ensure => running,
    enable => true,
  }

  # class { '::harden_docker': }

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
