require 'spec_helper'

describe "php::extension::pgsql" do
  let(:facts) { default_test_facts }
  let(:title) { "pgsql for 5.4.17" }
  let(:params) do
    {
      :php => "5.4.17",
    }
  end

  it do
    should contain_class("php::config")
    should contain_class("php::5_4_17")

    should contain_php_extension("pgsql for 5.4.17").with({
      :provider         => "php_source",
      :extension        => "pgsql",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-pgsql=/test/boxen/homebrew/opt/postgresql",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/pgsql.ini").with({
      :content => File.read("spec/fixtures/pgsql.ini"),
      :require => "Php_extension[pgsql for 5.4.17]"
    })
  end
end
