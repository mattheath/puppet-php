# Set up a PHP FPM pool listening on a socket
#
# Automatically ensures that php version is installed via phpenv & php-build
# and that PHP FPM is installed as a service for that version of PHP
#
# Usage:
#
#     php::fpm::pool { '5.4.10 for my project':
#       version => '5.4.10',
#       socket  => '/path/to/socket'
#     }
#
define php::fpm::pool(
  $version           = undef,
  $socket            = undef,
  $pm                = 'dynamic',
  $max_children      = 2,
  $start_servers     = 1,
  $min_spare_servers = 1,
  $max_spare_servers = 1,
  $ensure            = present,
) {
  require php::config

  $repo_dir = $dir ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $dir
  }

  $socket_path = $socket ? {
    undef   => "${boxen::config::socketdir}/${project_name}",
    default => $socket
  }

  $pool_name = $name

  if $ensure == present {
    # Requires php fpm version eg. php::fpm::5-4-10
    require join(['php', 'fpm', join(split($version, '[.]'), '-')], '::')

    # Create a default pool, as FPM won't start without one
    # Listen on a fake socket for now


    file { "${php::fpm::fpm_pool_config_dir}/${pool_name}.conf":
      content => template('php/php-fpm-pool.conf.erb'),
      before  => Service["dev.php-fpm.${version}"],
      notify  => Service["dev.php-fpm.${version}"],
    }
  }
}
