# Configure PHP-FPM to run a specific version of PHP


define php::fpm(
  $ensure  = present,
  $version = $name,
){
  include php::config

  if $version != 'system' and $ensure == present {
    # Require php version eg. php::5-4-10
    require join(['php', join(split($version, '[.]'), '-')], '::')

    $logdir  = "${php::config::logdir}"
    $logfile = "${logdir}/${version}.log"

    $root    = "${php::root}/versions/${name}"
    $cwd     = "${root}"
    $bin     = "${root}/sbin/php-fpm"
    $confdir = "${root}/etc"
    $conf    = "${confdir}/php-fpm.conf"
    $pool_confdir = "${root}/etc/pool.d"

    file { [
      $logdir,
      $pool_confdir
    ]:
      ensure => directory,
    }

    file { $conf:
      content => template('php/php-fpm.conf.erb'),
      before  => Service["dev.php-fpm"],
      notify  => Service["dev.php-fpm"],
    }

    file { "$pool_confdir/www.conf":
      content => template('php/php-fpm-pool.conf.erb'),
      require => File[$pool_confdir],
      before  => Service["dev.php-fpm"],
      notify  => Service["dev.php-fpm"],
    }

    file { "/Library/LaunchDaemons/dev.php-fpm.plist":
      content => template('php/dev.php-fpm.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
      notify  => Service["dev.php-fpm"],
    }

    service { "dev.php-fpm":
      ensure  => running,
      require => File["/Library/LaunchDaemons/dev.php-fpm.plist"],
    }

  }

}