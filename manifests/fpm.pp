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
  require php::config

  # Config file locations
  $version_config_root = "${php::config::configdir}/${version}"
  $fpm_config          = "${version_config_root}/php-fpm.conf"
  $fpm_pool_config_dir = "${version_config_root}/pool.d"
  $pid_file            = "${php::config::datadir}/${version}.pid"

  # Log files
  $error_log = "${php::config::logdir}/${version}.error.log"

  if $ensure == present {
    # Require php version eg. php::5-4-10
    # This will compile, install and set up config dirs if not present
    require join(['php', join(split($version, '[.]'), '-')], '::')

    # FPM Binary
    $bin = "${php::config::root}/versions/${version}/sbin/php-fpm"

    # Set up FPM config
    file { $fpm_config:
      content => template('php/php-fpm.conf.erb'),
      notify  => Php::Fpm::Service[$version],
    }

    # Set up FPM Pool configs
    file { $fpm_pool_config_dir:
      ensure  => directory,
      require => File[$version_config_root],
    }

    # Create a default pool, as FPM won't start without one
    # Listen on a fake socket for now
    $pool_name    = $version
    $socket_path  = "${boxen::config::socketdir}/${version}"
    $pm           = 'static'
    $max_children = 1

    # Additional non required options (as pm = static for this pool):
    $start_servers     = 1
    $min_spare_servers = 1
    $max_spare_servers = 1

    file { "${fpm_pool_config_dir}/${version}.conf":
      content => template('php/php-fpm-pool.conf.erb'),
    }

    # Launch our FPM Service

    php::fpm::service{ $version:
      ensure    => running,
      subscribe => File["${fpm_pool_config_dir}/${version}.conf"],
    }

  } else {

    # Stop service and kill configs
    # Stop service first as we need to unload the plist file

    file { [
        $fpm_config,
        $fpm_pool_config_dir,
      ]:
      ensure  => absent,
      require => Php::Fpm::Service[$version],
    }

    php::fpm::service{ $version:
      ensure => absent,
    }
  }

}