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

  # Set some nginx params to ensure that fastcgi actually works
  include php::fpm::fastcgi

  $repo_dir = $dir ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $dir
  }

  $socket_path = $socket ? {
    undef   => "${boxen::config::socketdir}/${project_name}",
    default => $socket
  }

  $pool_name = join(split($name, '[.] '), '-')

  if $ensure == present {
    # Requires php fpm version eg. php::fpm::5-4-10
    require join(['php', 'fpm', join(split($version, '[.]'), '-')], '::')

    # Create a pool config file
    file { "${php::config::configdir}/${version}/pool.d/${pool_name}.conf":
      content => template('php/php-fpm-pool.conf.erb'),
    }
  }
}
