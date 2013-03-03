# Class: php
#
# This module installs a full phpenv & php-build driven php stack
#
class php {
  require php::config
  include homebrew
  include wget
  include autoconf

  # We need php-build
  include php::php_build

  # Get rid of any pre-installed packages
  package { ['phpenv', 'php-build']: ensure => absent; }

  $phpenv_version = '9688906ae527e4068d96d5d8e0579973ecfdb5de' # Pin to latest version of dev branch as of 2013-02-20

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
      'gettext',
      'icu4c',
      'jpeg',
      'libpng',
      'homebrew/dupes/zlib',
      'mcrypt',
    ]:
    provider => homebrew,
    require  => Exec['tap-homebrew-dupes']
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
    require => [ File[$php::config::root], Class['git'] ]
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

  # Remove the PHP src repository we cached before switching to php-build
  file { "${root}/php-src":
    ensure => absent
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
