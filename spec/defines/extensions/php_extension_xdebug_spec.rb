require 'spec_helper'

describe "php::extension::xdebug" do
  let(:facts) { default_test_facts }
  let(:title) { "xdebug for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "2.2.1"
    }
  end

  it do
    should include_class("php::config")
    should include_class("php::5_4_17")

    should contain_php_extension("xdebug for 5.4.17").with({
      :extension     => "xdebug",
      :version       => "2.2.1",
      :package_name  => "xdebug-2.2.1",
      :package_url   => "http://xdebug.org/files/xdebug-2.2.1.tgz",
      :homebrew_path => "/test/boxen/homebrew",
      :phpenv_root   => "/test/boxen/phpenv",
      :php_version   => "5.4.17",
      :cache_dir     => "/test/boxen/data/php/cache/extensions",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/xdebug.ini").with({
      :content => File.read("spec/fixtures/xdebug.ini"),
      :require => "Php_extension[xdebug for 5.4.17]"
    })
  end
end
