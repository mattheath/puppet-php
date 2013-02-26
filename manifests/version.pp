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
  $version_config_dir  = "${php::config::configdir}/${version}"
  $php_ini             = "${version_config_dir}/php.ini"

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

    file { $version_config_dir:
      ensure => directory,
    }

    # Install PHP!

    exec { "php-install-${version}":
      command     => "${php::php_build::root}/bin/php-build ${version} ${php::root}/versions/${version}",
      cwd         => "${php::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
    }

    # Set up config files

    file { $php_ini:
      content => template('php/php.ini.erb'),
      require => File["${version_config_dir}"]
    }

  }
}
