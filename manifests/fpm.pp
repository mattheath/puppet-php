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

  # Current supported and secure versions
  $secure_5_6 = $php::config::secure_versions['5.6']
  $secure_5_5 = $php::config::secure_versions['5.5']
  $secure_5_4 = $php::config::secure_versions['5.4']

  # Specify secure version if no minor point specified
  if $version == '5' {
    $patch_version = $secure_5_6
  } elsif $version == '5.6' {
    $patch_version = $secure_5_6
  } elsif $version == '5.5' {
    $patch_version = $secure_5_5
  } elsif $version == '5.4' {
    $patch_version = $secure_5_4
  } else {
    $patch_version = $version
  }

  # Config file locations
  $version_config_root = "${php::config::configdir}/${patch_version}"
  $fpm_config          = "${version_config_root}/php-fpm.conf"
  $fpm_pool_config_dir = "${version_config_root}/pool.d"
  $pid_file            = "${php::config::datadir}/${patch_version}.pid"

  # Log files
  $error_log = "${php::config::logdir}/${patch_version}.fpm.error.log"

  if $ensure == present {
    # Require php version eg. php::version { '5_4_10': }
    # This will compile, install and set up config dirs if not present
    php_require($patch_version)

    # FPM Binary
    $bin = "${php::config::root}/versions/${patch_version}/sbin/php-fpm"

    # Set up FPM config
    file { $fpm_config:
      content => template('php/php-fpm.conf.erb'),
      notify  => Php::Fpm::Service[$patch_version],
    }

    # Set up FPM Pool config directory
    file { $fpm_pool_config_dir:
      ensure  => directory,
      recurse => true,
      force   => true,
      source  => 'puppet:///modules/php/empty-conf-dir',
      require => File[$version_config_root],
    }

    # Create a default pool, as FPM won't start without one
    # Listen on a fake socket for now
    $pool_name    = $patch_version
    $socket_path  = "${boxen::config::socketdir}/${patch_version}"
    $pm           = 'static'
    $max_children = 1

    # Additional non required options (as pm = static for this pool):
    $start_servers     = 1
    $min_spare_servers = 1
    $max_spare_servers = 1

    file { "${fpm_pool_config_dir}/${patch_version}.conf":
      content => template('php/php-fpm-pool.conf.erb'),
    }

    # Launch our FPM Service

    php::fpm::service{ $patch_version:
      ensure    => running,
      subscribe => File["${fpm_pool_config_dir}/${patch_version}.conf"],
    }

  } else {

    # Stop service and kill configs
    # Stop service first as we need to unload the plist file

    file { [
        $fpm_config,
        $fpm_pool_config_dir,
      ]:
      ensure  => absent,
      require => Php::Fpm::Service[$patch_version],
    }

    php::fpm::service{ $patch_version:
      ensure => absent,
    }
  }

}
