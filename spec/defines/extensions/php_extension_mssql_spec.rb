require 'spec_helper'

describe "php::extension::mssql" do
  let(:facts) { default_test_facts }
  let(:title) { "mssql for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
    }
  end

  it do
    should contain_class("php::dependencies::freetds")
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("mssql for 5.4.17").with({
      :provider         => "php_source",
      :extension        => "mssql",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-mssql=/test/boxen/homebrew/opt/freetds",
      :require          => "Package[freetds]"
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/mssql.ini").with({
      :content => File.read("spec/fixtures/mssql.ini"),
      :require => "Php_extension[mssql for 5.4.17]"
    })
  end
end
