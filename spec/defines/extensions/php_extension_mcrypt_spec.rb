require 'spec_helper'

describe "php::extension::mcrypt" do
  let(:facts) { default_test_facts }
  let(:title) { "mcrypt for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("mcrypt for 5.4.17").with({
      :provider         => "php_source",
      :extension        => "mcrypt",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-mcrypt=/test/boxen/homebrew/opt/mcrypt",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/mcrypt.ini").with({
      :content => File.read("spec/fixtures/mcrypt.ini"),
      :require => "Php_extension[mcrypt for 5.4.17]"
    })
  end
end
