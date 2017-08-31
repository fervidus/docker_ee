# Installs the Docker Enterprise Edition package
class docker_ee::configure {
  $devicemapper_content = @("DEVICEMAPPER"/L)
    {
      "storage-driver": "devicemapper"
    }
    | DEVICEMAPPER

  # Put EE repository URL in  /etc/yum/vars/dockerurl
  file { '/etc/docker':
    ensure  => directory,
  }

  file { '/etc/docker/daemon.json':
    ensure  => file,
    content => $devicemapper_content,
  }
}
