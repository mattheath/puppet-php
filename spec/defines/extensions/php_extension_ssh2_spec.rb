require 'spec_helper'

describe "php::extension::ssh2" do
  let(:pre_condition) { "class ssh2::lib {}" }
  let(:facts) { default_test_facts }
  let(:title) { "ssh2 for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "0.12"
    }
  end

  it do
    should contain_class("boxen::config")
    should contain_class("ssh2::lib")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("ssh2 for 5.4.17").with({
      :extension        => "ssh2",
      :version          => "0.12",
      :package_name     => "ssh2-0.12",
      :package_url      => "http://pecl.php.net/get/ssh2-0.12.tgz",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :provider         => "pecl",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/ssh2.ini").with({
      :content => File.read("spec/fixtures/ssh2.ini"),
      :require => "Php_extension[ssh2 for 5.4.17]"
    })
  end
end
