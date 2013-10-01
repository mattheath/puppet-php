require 'spec_helper'

describe "php::extension::imagick" do
  let(:pre_condition) { "class imagemagick {}" }
  let(:facts) { default_test_facts }
  let(:title) { "imagick for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "3.0.0"
    }
  end

  it do
    should include_class("php::config")
    should include_class("imagemagick")
    should include_class("php::5_4_17")

    should contain_php_extension("imagick for 5.4.17").with({
      :extension        => "imagick",
      :version          => "3.0.0",
      :package_name     => "imagick-3.0.0",
      :package_url      => "http://pecl.php.net/get/imagick-3.0.0.tgz",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :configure_params => "--with-imagick=/test/boxen/homebrew/opt/imagemagick",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/imagick.ini").with({
      :content => File.read("spec/fixtures/imagick.ini"),
      :require => "Php_extension[imagick for 5.4.17]"
    })
  end
end
