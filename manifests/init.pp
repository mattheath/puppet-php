# Class: php
#
# This module installs a full phpenv-driven php stack
#
class php {
  include boxen::config
  include homebrew

  $root = "${boxen::config::home}/phpenv"
  $phpenv_version = '9688906ae527e4068d96d5d8e0579973ecfdb5de' # Pin to latest version of dev branch as of 2013-02-20
  $ruby_build_version = 'v20130206'

  package { ['phpenv', 'php-build']: ensure => absent; }

  file {
    $root:
      ensure => directory;
    [
      "${root}/plugins",
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

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/phpenv/phpenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${phpenv_version}"

  exec { 'phpenv-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $root,
    creates => "${root}/bin/phpenv",
    require => [ File[$root], Class['git'] ]
  }

  exec { "ensure-phpenv-version-${phpenv_version}":
    command => "${git_fetch} && git reset --hard ${phpenv_version}",
    unless  => "git rev-parse HEAD | grep ${phpenv_version}",
    cwd     => $root,
    require => Exec['phpenv-setup-root-repo']
  }

  # This needs something to stop it running each time, rbenv class greps both
  # libexec and shims/gem
  exec { 'phpenv-rehash-post-install':
    command => "/bin/rm -rf ${root}/shims && PHPENV_ROOT=${root} ${root}/bin/phpenv rehash",
    require => Exec["ensure-phpenv-version-${phpenv_version}"],
  }

}
