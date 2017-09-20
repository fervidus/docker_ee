# Installs the Docker Enterprise Edition package
class docker_ee::configure {
  $devicemapper_content = @("DEVICEMAPPER"/L)
    {
      "storage-driver": "devicemapper"
    }
    | DEVICEMAPPER

  augeas { 'docker_storage_driver':
    lens    => 'Json.lns',
    incl    => '/etc/docker/daemon.json',
    changes => [
      'set dict/entry[.=\'storage-driver\'] storage-driver',
      'set dict/entry[.=\'storage-driver\']/string devicemapper',
    ],;
  }
}
