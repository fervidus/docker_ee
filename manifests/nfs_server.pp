# nfs_server.pp
#
# The nfs-client CLI command to test mounting...
# $ showmount -e <nfs-server-hostname-or-ip>
#
class docker_ee::nfs_server {
  class { '::nfs':
    server_enabled             => true,
    nfs_v4_idmap_domain        => $facts['domain'],
    nfs_v4_export_root         => '/export',
    nfs_v4_export_root_clients => '*(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)',
  }

  file { '/ifs':
    ensure => directory,
  }

  file { '/ifs/kubernetes':
    ensure => directory,
  }

  nfs::server::export { '/ifs/kubernetes':
    ensure  => 'mounted',
    clients => '*(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)',
  }
}
