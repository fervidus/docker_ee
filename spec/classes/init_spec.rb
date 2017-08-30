require 'spec_helper'
describe 'docker_ee' do
  context 'with default values for all parameters' do
    let(:params) { { 'docker_ee_url' => 'http://autostructure.io/docker.repo' } }

    it { should contain_class('docker_ee') }

    it { is_expected.to compile.with_all_deps }
  end
end
