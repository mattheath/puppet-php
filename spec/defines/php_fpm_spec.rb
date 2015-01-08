require 'spec_helper'

describe "php::fpm" do
  let(:facts) { default_test_facts }
  let(:title) { "5.4.17" }

  context 'ensure => present' do
    let(:params) do
      {
        :ensure  => "present",
        :version => "5.4.17"
      }
    end

    it do
      should contain_class("php::5_4_17")

      should contain_file("/test/boxen/config/php/5.4.17/php-fpm.conf").with({
        :content => File.read("spec/fixtures/php-fpm.conf"),
        :notify  => "Php::Fpm::Service[5.4.17]"
      })

      should contain_file("/test/boxen/config/php/5.4.17/pool.d").with({
        :ensure  => "directory",
        :recurse => "true",
        :force   => "true",
        :source  => "puppet:///modules/php/empty-conf-dir",
        :require => "File[/test/boxen/config/php/5.4.17]"
      })

      should contain_file("/test/boxen/config/php/5.4.17/pool.d/5.4.17.conf").with({
        :content => File.read("spec/fixtures/php-fpm-pool.conf")
      })

      should contain_php__fpm__service("5.4.17").with({
        :ensure    => "running",
        :subscribe => "File[/test/boxen/config/php/5.4.17/pool.d/5.4.17.conf]",
      })
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure  => "absent",
        :version => "5.4.17"
      }
    end

    it do
      [
        "/test/boxen/config/php/5.4.17/php-fpm.conf",
        "/test/boxen/config/php/5.4.17/pool.d"
      ].each do |path|
        should contain_file(path).with({
          :ensure  => "absent",
          :require => "Php::Fpm::Service[5.4.17]"
        })
      end

      should contain_php__fpm__service("5.4.17").with_ensure("absent")
    end
  end
end
