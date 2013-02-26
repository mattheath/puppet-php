# Class: php::php_build
#
# This module installs php-build which we'll use to install php versions
# https://github.com/CHH/php-build
#
class php::php_build {
  require php::config

  $root = "${php::config::root}/plugins/php-build"
  $php_build_version = 'v0.9.0'

  file {
    $root:
      ensure  => directory,
      require => File["${php::config::root}/plugins"];
    "${root}/bin":
      ensure  => directory,
      require => Exec['php-build-setup-root-repo'];
  }

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/CHH/php-build.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${php_build_version}"

  exec { 'php-build-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $root,
    creates => "${root}/bin/php-build",
    require => [ File[$root], Class['git'] ]
  }

  exec { "ensure-php-build-version-${php_build_version}":
    command => "${git_fetch} && git reset --hard ${php_build_version}",
    unless  => "git describe --tags --exact-match | grep ${php_build_version}",
    cwd     => $root,
    require => Exec['phpenv-setup-root-repo']
  }

  # Remove phpenv-install cruft
  # see https://github.com/CHH/php-build/issues/68
  file { "${root}/bin/phpenv-install":
    ensure => absent,
    require => Exec["ensure-php-build-version-${php_build_version}"],
  }

  # Override default build options to set boxen paths
  file { "${root}/share/php-build/default_configure_options":
    content => template('php/default_configure_options.erb'),
    require => Exec["ensure-php-build-version-${php_build_version}"],
  }

  # Nuke old install location
  file { "${boxen::config::home}/php-build":
    ensure => absent,
    force  => true
  }

}
