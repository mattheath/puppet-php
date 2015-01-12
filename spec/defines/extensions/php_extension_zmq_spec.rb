require 'spec_helper'

describe "php::extension::zmq" do
  let(:pre_condition) { "class zeromq {}" }
  let(:facts) { default_test_facts }
  let(:title) { "zmq for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "1.0.5"
    }
  end

  it do
    should contain_class("zeromq")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_repository("/test/boxen/data/php/cache/extensions/zmq").with({
      :source => "mkoppanen/php-zmq"
    })

    should contain_php_extension("zmq for 5.4.17").with({
      :provider         => "git",
      :extension        => "zmq",
      :version          => "1.0.5",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :require          => "Repository[/test/boxen/data/php/cache/extensions/zmq]",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/zmq.ini").with({
      :content => File.read("spec/fixtures/zmq.ini"),
      :require => "Php_extension[zmq for 5.4.17]"
    })
  end
end
