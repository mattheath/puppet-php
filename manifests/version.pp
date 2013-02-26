# Installs a php version via php-build, and sets up phpenv

# Options:

#
# Usage:
#
#     php::version { '5.3.20': }
#
define php::version(
  $ensure    = 'installed',
  $conf_opts = undef,
  $version   = $name
) {
  require php

  $dest   = "${php::root}/versions/${version}"
  $logdir = "${php::config::logdir}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {

    exec { "php-install-${version}":
      command     => "${php::php_build::root}/bin/php-build ${version} ${php::root}/versions/${version}",
      cwd         => "${php::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
    }

    file { "${dest}/etc":
      ensure  => directory,
      require => Exec["php-install-${version}"]
    }

    file { "${dest}/etc/php.ini":
      content => template('php/php.ini.erb'),
      require => File["${dest}/etc"]
    }

  }
}
