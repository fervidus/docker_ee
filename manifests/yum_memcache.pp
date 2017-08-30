# Installs and conficures Docker Enterprise Edition
class docker_ee::yum_memcache {
  # Refresh memcache
  exec { '/bin/yum makecache fast':
    refreshonly  => true,
  }
}
