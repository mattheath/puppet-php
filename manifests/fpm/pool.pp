# Set up a PHP-FPM pool listening on a socket
#
# Automatically ensures that the version of PHP is installed and
# PHP-FPM is installed as a service for that version
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
  $fpm_pool_config   = 'php/php-fpm-pool.conf.erb',
) {
  require php::config

  # Set defaults

  $repo_dir = $dir ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $dir
  }

  $socket_path = $socket ? {
    undef   => "${boxen::config::socketdir}/${project_name}",
    default => $socket
  }

  # Set config

  $fpm_pool_config_dir = "${php::config::configdir}/${version}/pool.d"
  $pool_name = join(split($name, '[.] '), '-')

  # Set up PHP-FPM pool

  if $ensure == present {
    # Ensure that the php fpm service for this php version is installed
    # eg. php::fpm::5-4-10
    include join(['php', 'fpm', join(split($version, '[.]'), '-')], '::')

    # Create a pool config file
    file { "${fpm_pool_config_dir}/${pool_name}.conf":
      content => template($fpm_pool_config),
      require => File[$fpm_pool_config_dir],
      notify  => Service["dev.php-fpm.${version}"],
    }
  }
}
