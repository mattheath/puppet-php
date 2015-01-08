require 'spec_helper'

describe "php::extension::pdo_dblib" do
  let(:facts) { default_test_facts }
  let(:title) { "pdo_dblib for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
    }
  end

  it do
    should contain_class("php::dependencies::freetds")
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("pdo_dblib for 5.4.17").with({
      :provider         => "php_source",
      :extension        => "pdo_dblib",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-pdo_dblib=/test/boxen/homebrew/opt/freetds",
      :require          => "Package[freetds]"
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/pdo_dblib.ini").with({
      :content => File.read("spec/fixtures/pdo_dblib.ini"),
      :require => "Php_extension[pdo_dblib for 5.4.17]"
    })
  end
end
