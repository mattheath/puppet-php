require 'spec_helper'

describe "php::fpm::fastcgi" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("nginx::config")

    should contain_file("/test/boxen/config/nginx/fastcgi_params").with({
      :source  => 'puppet:///modules/php/nginx_fastcgi_params',
      :require => "File[/test/boxen/config/nginx]",
      :notify  => "Service[dev.nginx]"
    })
  end
end
