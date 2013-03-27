# Class: php
#
# This module installs a full phpenv & php-build driven php stack
#
class php {
  require php::config
  require homebrew
  include wget
  include autoconf
  include libtool
  include pkgconfig
  include pcre

  # Get rid of any pre-installed packages
  package { ['phpenv', 'php-build']: ensure => absent; }

  $phpenv_version = '9688906ae527e4068d96d5d8e0579973ecfdb5de' # Pin to latest version of dev branch as of 2013-02-20

  file {
    [
      "${php::config::root}",
      "${php::config::logdir}",
      "${php::config::datadir}",
      "${php::config::pluginsdir}",
      "${php::config::cachedir}",
      "${php::config::extensioncachedir}",
    ]:
    ensure => directory
  }

  # Ensure we only have config files managed by Boxen
  # to prevent any conflicts by shipping a (nearly) empty
  # dir, and recursively purging
  file { $php::config::configdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    source => "puppet:///modules/php/empty-conf-dir",
  }

  file {
    [
      "${php::config::root}/phpenv.d",
      "${php::config::root}/phpenv.d/install",
      "${php::config::root}/shims",
      "${php::config::root}/versions",
      "${php::config::root}/libexec",
    ]:
      ensure  => directory,
      require => Exec['phpenv-setup-root-repo'];

    "${boxen::config::envdir}/phpenv.sh":
      source => 'puppet:///modules/php/phpenv.sh' ;
  }

  # Resolve dependencies

  exec { 'tap-homebrew-dupes':
    command => "brew tap homebrew/dupes",
    creates => "${homebrew::config::tapsdir}/homebrew-dupes",
  }

  package { [
      'freetype',
      'gmp',
      'icu4c',
      'jpeg',
      'libpng',
      'libevent',
      'mcrypt',
      'homebrew/dupes/zlib',
    ]:
    provider => homebrew,
    require  => Exec['tap-homebrew-dupes'],
  }

  # Need autoconf version less than 2.59 for php 5.3 (ewwwww)

  homebrew::formula { 'autoconf213':
    before => Package['boxen/brews/autoconf213'],
  }

  package { 'boxen/brews/autoconf213':
    ensure => '2.13-boxen1',
  }

  # Set up phpenv

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/phpenv/phpenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${phpenv_version}"

  exec { 'phpenv-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $php::config::root,
    creates => "${php::config::root}/bin/phpenv",
    require => [
      File[$php::config::root],
      Class['git'],
    ]
  }

  exec { "ensure-phpenv-version-${phpenv_version}":
    command => "${git_fetch} && git reset --hard ${phpenv_version}",
    unless  => "git rev-parse HEAD | grep ${phpenv_version}",
    cwd     => $php::config::root,
    require => Exec['phpenv-setup-root-repo']
  }

  # This needs something to stop it running each time, rbenv class greps both
  # libexec and shims/gem
  exec { 'phpenv-rehash-post-install':
    command => "/bin/rm -rf ${php::config::root}/shims && PHPENV_ROOT=${php::config::root} ${php::config::root}/bin/phpenv rehash",
    require => Exec["ensure-phpenv-version-${phpenv_version}"],
  }

  # Cache the PHP src repository we'll need this for extensions
  # and at some point building versions #todo
  repository { "${php::config::root}/php-src":
    source => "php/php-src",
  }

  # Shared PEAR data directory - used for downloads & cache
  file { "${php::config::datadir}/pear":
    ensure  => directory,
    owner   => $::boxen_user,
    group   => 'staff',
    require => File[$php::config::datadir],
  }

  # Kill off the legacy PHP-FPM daemon as we're moving to per version instances
  file { "/Library/LaunchDaemons/dev.php-fpm.plist":
    ensure  => 'absent',
    require => Service["dev.php-fpm"]
  }
  service { "dev.php-fpm":
    ensure => stopped,
  }

}
