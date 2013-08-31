require 'spec_helper'

describe "php" do
  let(:facts) { default_test_facts }
  let(:phpenv_version) { "9688906ae527e4068d96d5d8e0579973ecfdb5de" }

  it do
    should include_class("php::config")
    should include_class("homebrew")
    should include_class("wget")
    should include_class("autoconf")
    should include_class("libtool")
    should include_class("pkgconfig")
    should include_class("pcre")
    should include_class("libpng")

    should contain_package("phpenv").with({
      :ensure => "absent"
    })

    should contain_package("php-build").with({
      :ensure => "absent"
    })

    [
      "/test/boxen/phpenv",
      "/test/boxen/log/php",
      "/test/boxen/data/php",
      "/test/boxen/phpenv/plugins",
      "/test/boxen/data/php/cache",
      "/test/boxen/data/php/cache/extensions",
    ].each do |dir|
      should contain_file(dir).with_ensure("directory")
    end

    should contain_file("/test/boxen/config/php").with({
      :ensure  => "directory",
      :recurse => "true",
      :purge   => "true",
      :force   => "true",
      :source  => "puppet:///modules/php/empty-conf-dir"
    })

    [
      "/test/boxen/phpenv/phpenv.d",
      "/test/boxen/phpenv/phpenv.d/install",
      "/test/boxen/phpenv/shims",
      "/test/boxen/phpenv/versions",
      "/test/boxen/phpenv/libexec"
    ].each do |dir|
      should contain_file(dir).with({
        :ensure  => "directory",
        :require => "Exec[phpenv-setup-root-repo]"
      })
    end

    should contain_file("/test/boxen/env.d/phpenv.sh").with_source("puppet:///modules/php/phpenv.sh")

    [
      "freetype",
      "gmp",
      "icu4c",
      "jpeg",
      "libevent",
      "mcrypt"
    ].each do |pkg|
      should contain_package(pkg).with_provider("homebrew")
    end

    should contain_homebrew__formula("autoconf213").with({
      :before => "Package[boxen/brews/autoconf213]"
    })

    should contain_package("boxen/brews/autoconf213").with_ensure("2.13-boxen1")

    should contain_homebrew__formula("zlibphp").with({
      :source => "puppet:///modules/php/brews/zlib.rb",
      :before => "Package[boxen/brews/zlibphp]"
    })

    should contain_package("boxen/brews/zlibphp").with({
      :ensure => "1.2.8-boxen1"
    })

    should contain_exec("phpenv-setup-root-repo").with({
      :command => "git init . && git remote add origin https://github.com/phpenv/phpenv.git && git fetch -q origin && git reset --hard #{phpenv_version}",
      :cwd     => "/test/boxen/phpenv",
      :creates => "/test/boxen/phpenv/bin/phpenv",
      :require => ["File[/test/boxen/phpenv]", "Class[Git]"]
    })

    should contain_exec("ensure-phpenv-version-#{phpenv_version}").with({
      :command => "git fetch -q origin && git reset --hard #{phpenv_version}",
      :unless  => "git rev-parse HEAD | grep #{phpenv_version}",
      :cwd     => "/test/boxen/phpenv",
      :require => "Exec[phpenv-setup-root-repo]"
    })

    should contain_repository("/test/boxen/phpenv/php-src").with({
      :source => "php/php-src"
    })

    should contain_file("/test/boxen/data/php/pear").with({
      :ensure  => "directory",
      :owner   => "testuser",
      :group   => "staff",
      :require => "File[/test/boxen/data/php]",
    })

    should contain_file("/Library/LaunchDaemons/dev.php-fpm.plist").with({
      :ensure  => "absent",
      :require => "Service[dev.php-fpm]"
    })

    should contain_service("dev.php-fpm").with_ensure("stopped")
  end
end
