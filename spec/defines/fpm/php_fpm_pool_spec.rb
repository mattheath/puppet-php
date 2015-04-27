require 'spec_helper'

describe "php::fpm::pool" do
  let(:facts) { default_test_facts }
  let(:title) { "5.4.17 for test" }

  context "ensure => present" do
    let(:params) do
      {
        :ensure      => "present",
        :version     => "5.4.17",
        :socket_path => "/path/to/socket"
      }
    end

    it do
      should contain_class("php::config")
      should contain_php__fpm("5.4.17")

      should contain_file("/test/boxen/config/php/5.4.17/pool.d/5_4_17_for_test.conf").with({
        :content => File.read("spec/fixtures/php-fpm-pool-custom.conf"),
        :require => "File[/test/boxen/config/php/5.4.17/pool.d]",
        :notify  => "Service[dev.php-fpm.5.4.17]"
      })
    end
  end

end
