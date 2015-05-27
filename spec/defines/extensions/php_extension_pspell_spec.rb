require 'spec_helper'

describe "php::extension::pspell" do
  let(:facts) { default_test_facts }
  let(:title) { "pspell for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
    }
  end

  it do
    should contain_class("php::config")
    should contain_php__version("5.4.17")

    should contain_php_extension("pspell for 5.4.17").with({
      :provider         => "php_source",
      :extension        => "pspell",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-pspell=/test/boxen/homebrew/opt/aspell",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/pspell.ini").with({
      :content => File.read("spec/fixtures/pspell.ini"),
      :require => "Php_extension[pspell for 5.4.17]"
    })
  end
end
