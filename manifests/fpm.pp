# Configure a PHP-FPM instance running a specific version of PHP
#
# Usage:
#
#     php::fpm { '5.4.10': }
#
define php::fpm(
  $ensure  = present,
  $version = $name,
){
  require php

  # Config file locations
  $version_config_dir  = "${php::config::configdir}/${version}"
  $fpm_config          = "${version_config_dir}/php-fpm.conf"
  $fpm_pool_config_dir = "${version_config_dir}/pool.d"

  if $ensure == present {
    # Require php version eg. php::5-4-10
    # This will compile, install and set up config dirs if not present
    require join(['php', join(split($version, '[.]'), '-')], '::')

    # Set up FPM config
    file { $fpm_config:
      content => template('php/php-fpm.conf.erb'),
      before  => Service["dev.php-fpm.${version}"],
      notify  => Service["dev.php-fpm.${version}"],
    }

    # Set up FPM Pool configs
    file { $fpm_pool_config_dir:
      ensure  => directory,
      require => File[$version_config_dir],
    }

    # Register and fire up our FPM instance

    file { "/Library/LaunchDaemons/dev.php-fpm.${version}.plist":
      content => template('php/dev.php-fpm.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
      notify  => Service["dev.php-fpm.${version}"],
    }

    service { "dev.php-fpm.${version}":
      ensure  => running,
      require => File["/Library/LaunchDaemons/dev.php-fpm.${version}.plist"],
    }

  } else {

    # Stop service and kill configs
    # Stop service first as we need to unload the plist file

    file { [
        $fpm_config,
        $fpm_pool_config_dir,
        "/Library/LaunchDaemons/dev.php-fpm.${version}.plist",
      ]:
      ensure  => absent,
      require => Service["dev.php-fpm.${version}"]
    }

    service { "dev.php-fpm.${version}":
      ensure => stopped
    }

  }

}