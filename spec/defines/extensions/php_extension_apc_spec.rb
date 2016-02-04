require 'spec_helper'

describe "php::extension::apc" do
  let(:facts) { default_test_facts }
  let(:title) { "apc for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "3.1.13"
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("apc for 5.4.17").with({
      :extension      => "apc",
      :version        => "3.1.13",
      :package_name   => "APC-3.1.13",
      :package_url    => "http://pecl.php.net/get/APC-3.1.13.tgz",
      :homebrew_path  => "/test/boxen/homebrew",
      :phpenv_root    => "/test/boxen/phpenv",
      :php_version    => "5.4.17",
      :cache_dir      => "/test/boxen/data/php/cache/extensions"
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/apc.ini").with({
      :content => File.read("spec/fixtures/apc.ini"),
      :require => "Php_extension[apc for 5.4.17]",
    })
  end
end
