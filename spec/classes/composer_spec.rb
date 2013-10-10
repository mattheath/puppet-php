require 'spec_helper'

describe "php::composer" do
  let(:facts) { default_test_facts }

  it do
    should include_class("php")

    should contain_exec("download-php-composer").with({
      :command => "curl -sS https://getcomposer.org/installer | /usr/bin/php -d detect_unicode=Off",
      :creates => "/test/boxen/phpenv/composer.phar",
      :cwd     => "/test/boxen/phpenv",
      :require => "Exec[phpenv-setup-root-repo]"
    })

    should contain_file("/test/boxen/phpenv/composer.phar").with({
      :mode => "0755"
    })

    should contain_file("/test/boxen/phpenv/bin/composer").with({
      :ensure => "link",
      :target => "/test/boxen/phpenv/composer.phar"
    })
  end
end
