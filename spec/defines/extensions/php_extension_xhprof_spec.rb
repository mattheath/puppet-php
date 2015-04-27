require 'spec_helper'

describe "php::extension::xhprof" do
  let(:facts) { default_test_facts }
  let(:title) { "xhprof for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "0.9.4"
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("xhprof for 5.4.17").with({
      :extension     => "xhprof",
      :version       => "0.9.4",
      :package_name  => "xhprof-0.9.4",
      :package_url   => "http://pecl.php.net/get/xhprof-0.9.4.tgz",
      :homebrew_path => "/test/boxen/homebrew",
      :phpenv_root   => "/test/boxen/phpenv",
      :php_version   => "5.4.17",
      :cache_dir     => "/test/boxen/data/php/cache/extensions",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/xhprof.ini").with({
      :content => File.read("spec/fixtures/xhprof.ini"),
      :require => "Php_extension[xhprof for 5.4.17]"
    })
  end
end
