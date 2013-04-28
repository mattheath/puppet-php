# Manages a PHP FPM service
#
# Usage:
#
#     php::fpm::service { '5.4.10':
#       ensure => running
#     }
#
define php::fpm::service(
  $version           = $name,
  $ensure            = running,
) {
  require php::config
  include php::fpm::fastcgi

  # Config file locations
  $fpm_config = "${php::config::configdir}/${version}/php-fpm.conf"

  # Log files
  $logfile = "${php::config::logdir}/${version}.error.log"

  # FPM Binary
  $bin = "${php::config::root}/versions/${version}/sbin/php-fpm"

  # Working Directory?
  $cwd = "${php::config::root}/versions/${version}"

  if $ensure == running {

    # Register and fire up our FPM instance

    file { "/Library/LaunchDaemons/dev.php-fpm.${version}.plist":
      content => template('php/dev.php-fpm.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
    }

    service { "dev.php-fpm.${version}":
      ensure    => running,
      subscribe => File["/Library/LaunchDaemons/dev.php-fpm.${version}.plist"],
      require   => Class['php::fpm::fastcgi'],
    }

  } else {

    file { "/Library/LaunchDaemons/dev.php-fpm.${version}.plist":
      ensure  => absent,
      require => Service["dev.php-fpm.${version}"],
    }

    service { "dev.php-fpm.${version}":
      ensure  => stopped,
    }

  }
}