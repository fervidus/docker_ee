# Class: docker_ee
# ===========================
#
# @summary Installs Docker EE on RedHat.
#
# @param docker_ee_url     The Docker EE URL you will be assigned by the vendor.
# @param docker_os_version The version of the RedHat OS you are using.
#
# @example
#    class { 'docker_ee':
#      docker_ee_url => 'https://storebits.docker.com/ee/abc123',
#    }
#
# Authors
# -------
#
# Author Name bryan@autostructure.io
#
# Copyright
# ---------
#
# Copyright 2017 Autostructure
#
class docker_ee(
  Stdlib::Httpurl $docker_ee_url,
  Numeric $docker_os_version = 7,
  ) {
  class { '::docker_ee::pre_install': }
  ~> class { '::docker_ee::yum_memcache': }
  -> class { '::docker_ee::install': }
  -> Class['docker_ee']
}
