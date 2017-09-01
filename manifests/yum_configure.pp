# Run yum config manager to add repo
class docker_ee::yum_configure {
  # Refresh memcache
  exec { "/bin/yum-config-manager --add-repo ${::docker_ee::docker_ee_url}/rhel/docker-ee.repo":
    creates  => '/etc/yum.repos.d/docker-ee.repo',
  }
}
