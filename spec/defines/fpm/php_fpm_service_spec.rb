require 'spec_helper'

describe "php::fpm::service" do
  let(:facts) { default_test_facts }
  let(:title) { "5.4.17" }

  context "ensure => running" do
    let(:params) do
      {
        :ensure => "running"
      }
    end
    it do
      should contain_class("php::config")
      should contain_class("nginx::config")
      should contain_class("php::fpm::fastcgi")

      should contain_file("/Library/LaunchDaemons/dev.php-fpm.5.4.17.plist").with({
        :content => File.read("spec/fixtures/dev.php-fpm.plist"),
        :group   => "wheel",
        :owner   => "root"
      })

      should contain_service("dev.php-fpm.5.4.17").with({
        :ensure    => "running",
        :subscribe => "File[/Library/LaunchDaemons/dev.php-fpm.5.4.17.plist]",
        :require   => "File[/test/boxen/config/nginx/fastcgi_params]"
      })
    end
  end

  context "ensure => stopped" do
    let(:params) do
      {
        :ensure => "stopped"
      }
    end

    it do
      should contain_file("/Library/LaunchDaemons/dev.php-fpm.5.4.17.plist").with({
        :ensure  => "absent",
        :require => "Service[dev.php-fpm.5.4.17]"
      })

      should contain_service("dev.php-fpm.5.4.17").with({
        :ensure  => "stopped"
      })
    end
  end
end
