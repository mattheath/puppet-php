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

  # Install location
  $dest = "${php::config::root}/versions/${version}"

  # Log locations
  $error_log = "${php::config::logdir}/${version}.error.log"

  # Config locations
  $version_config_root  = "${php::config::configdir}/${version}"
  $php_ini              = "${version_config_root}/php.ini"
  $conf_d               = "${version_config_root}/conf.d"

  if $ensure == 'absent' {

    # If we're nuking a version of PHP also ensure we shut down
    # and get rid of the PHP FPM Service & config

    php::fpm { $version:
      ensure => 'absent'
    }

    file {
      [
        $dest,
        $version_config_root,
      ]:
      ensure => absent,
      force  => true
    }

  } else {

    # Set up config directories

    file { $version_config_root:
      ensure => directory,
    }

    file { $conf_d:
      ensure  => directory,
      purge   => true,
      force   => true,
      require => File[$version_config_root],
    }

    # Install PHP!

    exec { "php-install-${version}":
      command     => "${php::php_build::root}/bin/php-build ${version} ${php::config::root}/versions/${version}",
      cwd         => "${php::config::root}/versions",
      environment => "PHP_BUILD_CONFIGURE_OPTS=--with-config-file-path=${php_ini} --with-config-file-scan-dir=${conf_d}",
      provider    => 'shell',
      timeout     => 0,
      creates     => "${dest}/bin/php",
      require     => File[$php_ini],
    }

    # Set up config files

    file { $php_ini:
      content => template('php/php.ini.erb'),
      require => File["${version_config_root}"]
    }

    # Log files

    file { $error_log:
      owner => $::boxen_user,
      mode  => 644,
    }

  }
}
