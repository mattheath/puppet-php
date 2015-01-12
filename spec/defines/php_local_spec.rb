require 'spec_helper'

describe "php::local" do
  let(:facts) { default_test_facts }
  let(:title) { '/tmp' }

  context 'ensure => present' do
    let(:params) do
      {
        :version => '5.4.17'
      }
    end

    it do
      should contain_class("php::config")
      should contain_class('php::5_4_17')

      should contain_file('/tmp/.php-version').with({
        :ensure  => "present",
        :content => "5.4.17\n",
        :replace => "true"
      })
    end
  end

  context 'ensure => absent' do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_class("php::config")
      should contain_file('/tmp/.php-version').with_ensure('absent')
    end
  end
end
