# Installs and conficures Docker Enterprise Edition
class docker_ee::install {
  # Put EE repository URL in  /etc/yum/vars/dockerurl
  package { 'docker-ee.':
    ensure => installed,
  }
}
