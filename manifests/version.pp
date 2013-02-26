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
  $php_ini              = "${version_config_dir}/php.ini"
  $conf_d               = "${version_config_dir}/conf.d"

  if $ensure == 'absent' {

    file {
      [
        $dest,
        $version_config_dir,
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
      require => File[$version_config_root],
    }

    # Install PHP!
    exec { "php-install-${version}":
      command     => "${php::php_build::root}/bin/php-build ${version} ${php::config::root}/versions/${version}",
      cwd         => "${php::config::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
      require     => File[$php_ini],
    }

    # Set up config files

    file { $php_ini:
      content => template('php/php.ini.erb'),
      require => File["${version_config_root}"]
    }

  }
}
