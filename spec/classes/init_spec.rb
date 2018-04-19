require 'spec_helper'

describe 'docker_ee' do
  context 'with default values for all parameters' do
    let(:params) { { 'docker_ee_url' => 'http://autostructure.io/docker.repo' } }

    it { is_expected.to contain_class('docker_ee') }
    it { is_expected.to contain_class('docker_ee::pre_install').that_comes_before('Class[docker_ee::yum_configure]') }
    it { is_expected.to contain_class('docker_ee::yum_configure').that_notifies('Class[docker_ee::yum_memcache]') }
    it { is_expected.to contain_class('docker_ee::yum_memcache').that_comes_before('Class[docker_ee::install]') }
    it { is_expected.to contain_class('docker_ee::install').that_comes_before('Class[docker_ee::configure]') }
    it { is_expected.to contain_class('docker_ee::configure').that_notifies('Class[docker_ee::run]') }
    it { is_expected.to contain_class('docker_ee::run') }

    it { is_expected.to contain_package('device-mapper-persistent-data') }
    it { is_expected.to contain_package('lvm2') }
    it { is_expected.to contain_package('yum-utils') }
    it { is_expected.to contain_package('docker-ee') }

    it { is_expected.to contain_file('/etc/yum/vars/dockerosversion') }
    it { is_expected.to contain_file('/etc/yum/vars/dockerurl') }
    # it { is_expected.to contain_file('/etc/docker/daemon.json') }

    it { is_expected.to contain_exec('/bin/yum makecache fast') }
    it { is_expected.to contain_exec('/bin/yum-config-manager --add-repo http://autostructure.io/docker.repo/rhel/docker-ee.repo').that_notifies('Exec[/bin/yum makecache fast]') }

    it { is_expected.to contain_service('docker') }

    it { is_expected.to compile.with_all_deps }
  end
end
