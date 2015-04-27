require 'spec_helper'

describe "php::extension::intl" do
  let(:facts) { default_test_facts }
  let(:title) { "intl for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "2.0.1"
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("intl for 5.4.17").with({
      :extension        => "intl",
      :version          => "2.0.1",
      :package_name     => "intl-2.0.1",
      :package_url      => "http://pecl.php.net/get/intl-2.0.1.tgz",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :configure_params => "--with-icu-dir=/test/boxen/homebrew/opt/icu4c"
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/intl.ini").with({
      :content => File.read("spec/fixtures/intl.ini"),
      :require => "Php_extension[intl for 5.4.17]"
    })
  end
end
