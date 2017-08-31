# Adds the YUM meta information necessary to configure the YUM repo.
class docker_ee::pre_install {
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
    'docker-selinux',
    'docker-engine-selinux',
    'docker-engine'
  ]

  # Remove old docker installs
  $docker_ee_remove_packages.each | Integer $index, String $package_name | {
    package { $package_name:
      ensure => absent,
    }
  }

  $docker_ee_required_packages = ['yum-utils', 'device-mapper-persistent-data', 'lvm2']

  $docker_ee_required_packages.each | Integer $index, String $package_name | {
    package { $package_name:
      ensure => present,
    }
  }

  # SEt yumrepo
  yumrepo { "${docker_ee::docker_ee_url}/rhel/docker-ee.repo": }
}
