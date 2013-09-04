require 'spec_helper'

describe "php::extension::pecl_http" do
  let(:facts) { default_test_facts }
  let(:title) { "pecl_http for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "1.7.5"
    }
  end

  it do
    should include_class("boxen::config")
    should include_class("zookeeper")
    should include_class("php::config")
    should include_class("php::5_4_17")

    should contain_php_extension("pecl_http for 5.4.17").with({
      :extension     => "pecl_http",
      :version       => "1.7.5",
      :package_name  => "pecl_http-1.7.5",
      :package_url   => "http://pecl.php.net/get/pecl_http-1.7.5.tgz",
      :homebrew_path => "/test/boxen/homebrew",
      :phpenv_root   => "/test/boxen/phpenv",
      :php_version   => "5.4.17",
      :cache_dir     => "/test/boxen/data/php/cache/extensions",
      :compiled_name => "http.so"
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/pecl_http.ini").with({
      :content => File.read("spec/fixtures/pecl_http.ini"),
      :require => "Php_extension[pecl_http for 5.4.17]"
    })
  end
end
