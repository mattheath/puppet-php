require 'spec_helper'

describe "php::version" do
  let(:facts) { default_test_facts }
  let(:title) { "5.4.17" }

  it do
    should contain_class("php")
    should contain_class("boxen::config")
  end

  context 'ensure => installed' do
    let(:params) do
      {
        :ensure  => "installed",
        :version => "5.4.17"
      }
    end

    it do
      should contain_file("/test/boxen/data/php/5.4.17").with_ensure("directory")
      should contain_file("/test/boxen/config/php/5.4.17").with_ensure("directory")
      should contain_file("/test/boxen/config/php/5.4.17/conf.d").with({
        :ensure  => "directory",
        :purge   => "true",
        :force   => "true",
        :require => "File[/test/boxen/config/php/5.4.17]"
      })

      should contain_file("/test/boxen/phpenv/versions/5.4.17/modules").with({
        :ensure  => "directory",
        :require => "Php_version[5.4.17]"
      })

      should contain_file("/test/boxen/config/php/5.4.17/php.ini").with({
        :content => File.read("spec/fixtures/php.ini"),
        :require => "File[/test/boxen/config/php/5.4.17]"
      })

      should contain_file("/test/boxen/log/php/5.4.17.error.log").with({
        :owner => "testuser",
        :mode  => "0644"
      })

      should contain_php_version("5.4.17").with({
        :user          => "testuser",
        :user_home     => "/Users/testuser",
        :phpenv_root   => "/test/boxen/phpenv",
        :version       => "5.4.17",
        :homebrew_path => "/test/boxen/homebrew",
        :require       => [
          "Repository[/test/boxen/phpenv/php-src]",
          "Package[gettext]",
          "Package[boxen/brews/freetypephp]",
          "Package[gmp]",
          "Package[icu4c]",
          "Package[jpeg]",
          "Package[libpng]",
          "Package[mcrypt]",
          "Package[boxen/brews/zlibphp]",
          "Package[autoconf]",
          "Package[boxen/brews/autoconf213]",
        ],
        :notify        => "Exec[phpenv-rehash-post-install-5.4.17]",
      })

      should contain_file("/test/boxen/phpenv/versions/5.4.17").with({
        :ensure  => "directory",
        :owner   => "testuser",
        :group   => "staff",
        :recurse => "true",
        :require => "Php_version[5.4.17]"
      })

      should contain_exec("phpenv-rehash-post-install-5.4.17").with({
        :command     => "/bin/rm -rf /test/boxen/phpenv/shims && PHPENV_ROOT=/test/boxen/phpenv /test/boxen/phpenv/bin/phpenv rehash",
        :require     => "Php_version[5.4.17]",
        :refreshonly => "true",
      })

      should contain_file("/test/boxen/data/php/5.4.17/cache").with({
        :ensure  => "directory",
        :require => "File[/test/boxen/data/php/5.4.17]",
      })

      should contain_exec("pear-5.4.17-cache_dir").with({
        :command => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-set cache_dir /test/boxen/data/php/pear",
        :unless  => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-get cache_dir | grep -i /test/boxen/data/php/pear",
        :require => [
          "Php_version[5.4.17]",
          "File[/test/boxen/data/php/pear]"
        ]
      })

      should contain_exec("pear-5.4.17-download_dir").with({
        :command => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-set download_dir /test/boxen/data/php/pear",
        :unless  => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-get download_dir | grep -i /test/boxen/data/php/pear",
        :require => [
          "Php_version[5.4.17]",
          "File[/test/boxen/data/php/pear]"
        ]
      })

      should contain_exec("pear-5.4.17-temp_dir").with({
        :command => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-set temp_dir /test/boxen/data/php/pear",
        :unless  => "/test/boxen/phpenv/versions/5.4.17/bin/pear config-get temp_dir | grep -i /test/boxen/data/php/pear",
        :require => [
          "Php_version[5.4.17]",
          "File[/test/boxen/data/php/pear]"
        ]
      })
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure  => "absent",
        :version => "5.4.17"
      }
    end

    it do
      should contain_php__fpm("5.4.17").with_ensure("absent")

      [
        "/test/boxen/phpenv/versions/5.4.17",
        "/test/boxen/config/php/5.4.17",
        "/test/boxen/data/php/5.4.17"
      ].each do |dir|
        should contain_file(dir).with({
          :ensure => "absent",
          :force  => "true"
        })
      end
    end
  end
end
