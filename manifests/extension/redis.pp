# Installs the redis php extension for a specific version of php.
#
# Usage:
#
#     php::extension::redis { 'redis for 5.4.10':
#       version   => '2.2.3',
#       php       => '5.4.10',
#     }
#
define php::extension::redis(
  $php,
  $version = '2.2.3'
) {
  require redis

  require php::config
  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'redis'

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Clone the source repository
  repository { "${php::config::extensioncachedir}/redis":
    source => 'nicolasff/phpredis'
  }

  # Build & install the extension
  php_extension { $name:
    provider       => 'git',

    extension      => $extension,
    version        => $version,

    homebrew_path  => $boxen::config::homebrewdir,
    phpenv_root    => $php::config::root,
    php_version    => $php,

    cache_dir      => $php::config::extensioncachedir,
    require        => Repository["${php::config::extensioncachedir}/redis"],
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
