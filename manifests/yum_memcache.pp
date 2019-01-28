# Reset the YUM memchache to reflect the newly added repoistory
class docker_ee::yum_memcache {
  # Refresh memcache
  exec { '/bin/yum makecache -y fast':
    refreshonly  => true,
  }
}
