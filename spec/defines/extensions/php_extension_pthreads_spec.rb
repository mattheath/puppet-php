require 'spec_helper'

describe "php::extension::pthreads" do
  let(:facts) { default_test_facts }
  let(:title) { "pthreads for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "2.0.10"
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("pthreads for 5.4.17").with({
      :extension      => "pthreads",
      :version        => "2.0.10",
      :package_name   => "pthreads-2.0.10",
      :package_url    => "http://pecl.php.net/get/pthreads-2.0.10.tgz",
      :homebrew_path  => "/test/boxen/homebrew",
      :phpenv_root    => "/test/boxen/phpenv",
      :php_version    => "5.4.17",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/pthreads.ini").with({
      :content => File.read("spec/fixtures/pthreads.ini"),
      :require => "Php_extension[pthreads for 5.4.17]"
    })
  end
end
