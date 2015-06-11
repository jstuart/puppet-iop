require 'spec_helper'

describe 'iop' do
  context "operatingsystem => #{default_facts[:operatingsystem]}" do

    context 'operatingsystemmajrelease => 6' do
      let :facts do
        default_facts.merge({
          :operatingsystemrelease     => '6.4',
          :operatingsystemmajrelease  => '6',
        })
      end

    it { should create_class('iop') }

      #it do
      #should contain_file("/etc/yum.repos.d/ambari.repo").with({
      #  'ensure' => 'file',
      #})
      #end

      #it do
      #  should contain_package('ambari-agent').with('ensure' => 'latest')
      #end

    end

  end
end