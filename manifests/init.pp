# Class: php
#
# This module installs a full phpenv & php-build driven php stack
#
# Usage:
#
#     include php
#

class php(
  $root               = undef,
  $logdir             = undef,
  $configdir          = undef,
  $datadir            = undef,
  $pluginsdir         = undef,
  $cachedir           = undef,
  $extensioncachedir  = undef,
  $configure_params   = undef,
) {
  include boxen::config

  validate_string(
    $root,
    $logdir,
    $configdir,
    $datadir,
    $pluginsdir,
    $cachedir,
    $extensioncachedir,
  )

  validate_hash(
    $configure_params
  )

  class { 'php::config':
    root              => $root,
    logdir            => $logdir,
    configdir         => $configdir,
    datadir           => $datadir,
    pluginsdir        => $pluginsdir,
    cachedir          => $cachedir,
    extensioncachedir => $extensioncachedir,
    configure_params  => $configure_params,
  }

  require homebrew
  include wget
  include stdlib
  include autoconf
  include libtool
  include pkgconfig
  include pcre
  include libpng

  # Get rid of any pre-installed packages
  package { ['phpenv', 'php-build']: ensure => absent; }

  $phpenv_version = '6499bb6c7b645af3f4e67f7e17708d5ee208453f' # Pin to latest version of dev branch as of 2013-10-11

  file {
    [
      $root,
      $logdir,
      $datadir,
      $pluginsdir,
      $cachedir,
      $extensioncachedir,
    ]:
    ensure => directory
  }

  # Ensure we only have config files managed by Boxen
  # to prevent any conflicts by shipping a (nearly) empty
  # dir, and recursively purging
  file { $configdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    source  => 'puppet:///modules/php/empty-conf-dir',
  }

  file {
    [
      "${root}/phpenv.d",
      "${root}/phpenv.d/install",
      "${root}/shims",
      "${root}/versions",
      "${root}/libexec",
    ]:
      ensure  => directory,
      require => Exec['phpenv-setup-root-repo'];

    "${boxen::config::envdir}/phpenv.sh":
      source => 'puppet:///modules/php/phpenv.sh' ;
  }

  # Resolve dependencies
  ensure_packages( [ 'libevent', 'gmp', 'icu4c', 'jpeg', 'mcrypt', ] )

  # Install freetype version 2.4.11 due to conflict with GD
  # See https://github.com/boxen/puppet-php/issues/25

  homebrew::formula { 'freetypephp':
    source => 'puppet:///modules/php/brews/freetype.rb',
    before => Package['boxen/brews/freetypephp'],
  }

  package { 'boxen/brews/freetypephp':
    ensure => '2.4.11',
  }

  # Need autoconf version less than 2.59 for php 5.3 (ewwwww)

  homebrew::formula { 'autoconf213':
    before => Package['boxen/brews/autoconf213'],
  }

  package { 'boxen/brews/autoconf213':
    ensure => '2.13-boxen1',
  }

  # PHP 5.5 drops support for Bison 2.3 which is shipped with OSX
  # Therefore need a later version, which we'll again sandbox just for this

  homebrew::formula { 'bisonphp26':
    source => 'puppet:///modules/php/brews/bison26.rb',
    before => Package['boxen/brews/bisonphp26'],
  }

  package { 'boxen/brews/bisonphp26':
    ensure => '2.6.4-boxen1',
  }

  # Install dupe version of zlib as tapping homebrew dupes appears to have
  # broken. I've also tried to build a specific zlib module, but this also
  # will not currently install via brew within boxen
  #
  # See https://github.com/boxen/puppet-homebrew/issues/14
  #
  # Note: this will work for newly installed versions of PHP, but will NOT
  # work for versions of PHP installed prior to this. The best solution you
  # have is to remove those versions manually and Boxen will re-install

  homebrew::formula { 'zlibphp':
    source => 'puppet:///modules/php/brews/zlib.rb',
    before => Package['boxen/brews/zlibphp'] ;
  }

  package { 'boxen/brews/zlibphp':
    ensure => '1.2.8-boxen1',
  }

  # Set up phpenv

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/phpenv/phpenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${phpenv_version}"

  exec { 'phpenv-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $root,
    creates => "${root}/bin/phpenv",
    require => [
      File[$root],
      Class['git'],
    ]
  }

  exec { "ensure-phpenv-version-${phpenv_version}":
    command => "${git_fetch} && git reset --hard ${phpenv_version}",
    unless  => "git rev-parse HEAD | grep ${phpenv_version}",
    cwd     => $root,
    require => Exec['phpenv-setup-root-repo']
  }

  # Cache the PHP src repository we'll need this for extensions
  # and at some point building versions #todo
  repository { "${root}/php-src":
    source => 'php/php-src',
  }

  # Shared PEAR data directory - used for downloads & cache
  file { "${datadir}/pear":
    ensure  => directory,
    owner   => $::boxen_user,
    group   => 'staff',
    require => File[$datadir],
  }

  # Kill off the legacy PHP-FPM daemon as we're moving to per version instances
  file { '/Library/LaunchDaemons/dev.php-fpm.plist':
    ensure  => 'absent',
    require => Service['dev.php-fpm']
  }
  service { 'dev.php-fpm':
    ensure => stopped,
  }

}
