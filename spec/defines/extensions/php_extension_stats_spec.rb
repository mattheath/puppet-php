require 'spec_helper'

describe "php::extension::stats" do
  let(:facts) { default_test_facts }
  let(:title) { "stats for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "1.0.3"
    }
  end

  it do
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("stats for 5.4.17").with({
      :extension      => "stats",
      :version        => "1.0.3",
      :package_name   => "stats-1.0.3",
      :package_url    => "http://pecl.php.net/get/stats-1.0.3.tgz",
      :homebrew_path  => "/test/boxen/homebrew",
      :phpenv_root    => "/test/boxen/phpenv",
      :php_version    => "5.4.17",
      :cache_dir      => "/test/boxen/data/php/cache/extensions",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/stats.ini").with({
      :content => File.read("spec/fixtures/stats.ini"),
      :require => "Php_extension[stats for 5.4.17]"
    })
  end
end
