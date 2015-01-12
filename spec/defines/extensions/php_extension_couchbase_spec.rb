require 'spec_helper'

describe "php::extension::couchbase" do
  let(:pre_condition) { "class couchbase::lib {}" }
  let(:facts) { default_test_facts }
  let(:title) { "couchbase for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "1.1.2"
    }
  end

  it do
    should contain_class("couchbase::lib")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_repository("/test/boxen/data/php/cache/extensions/couchbase").with({
      :source => "couchbase/php-ext-couchbase"
    })

    should contain_php_extension("couchbase for 5.4.17").with({
      :provider         => "git",
      :extension        => "couchbase",
      :version          => "1.1.2",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :require          => "Repository[/test/boxen/data/php/cache/extensions/couchbase]",
      :configure_params => "--with-couchbase=/test/boxen/homebrew/opt/libcouchbase",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/couchbase.ini").with({
      :content => File.read("spec/fixtures/couchbase.ini"),
      :require => "Php_extension[couchbase for 5.4.17]"
    })
  end
end
