require 'spec_helper'

describe "php::extension::zookeeper" do
  let(:pre_condition) { "class zookeeper {}" }
  let(:facts) { default_test_facts }
  let(:title) { "zookeeper for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "0.2.1"
    }
  end

  it do
    should contain_class("boxen::config")
    should contain_class("zookeeper")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("zookeeper for 5.4.17").with({
      :extension     => "zookeeper",
      :version       => "0.2.1",
      :package_name  => "zookeeper-0.2.1",
      :package_url   => "http://pecl.php.net/get/zookeeper-0.2.1.tgz",
      :homebrew_path => "/test/boxen/homebrew",
      :phpenv_root   => "/test/boxen/phpenv",
      :php_version   => "5.4.17",
      :cache_dir     => "/test/boxen/data/php/cache/extensions",
      :configure_params => "--with-libzookeeper-dir=/test/boxen/homebrew/opt/zookeeper",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/zookeeper.ini").with({
      :content => File.read("spec/fixtures/zookeeper.ini"),
      :require => "Php_extension[zookeeper for 5.4.17]"
    })
  end
end
