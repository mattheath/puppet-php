require 'spec_helper'

describe "php::extension::memcached" do
  let(:pre_condition) { "class memcached::lib {}" }
  let(:facts) { default_test_facts }
  let(:title) { "memcached for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "2.1.0"
    }
  end

  it do
    should contain_class("boxen::config")
    should contain_class("memcached::lib")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("memcached for 5.4.17").with({
      :extension        => "memcached",
      :version          => "2.1.0",
      :package_name     => "memcached-2.1.0",
      :package_url      => "http://pecl.php.net/get/memcached-2.1.0.tgz",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :configure_params => "--with-libmemcached-dir=/test/boxen/homebrew/opt/libmemcached",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/memcached.ini").with({
      :content => File.read("spec/fixtures/memcached.ini"),
      :require => "Php_extension[memcached for 5.4.17]"
    })
  end
end
