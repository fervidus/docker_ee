# Installs the Docker Enterprise Edition package
class docker_ee::run {
  service { 'docker':
    ensure => running,
    enable => true,
  }
}
