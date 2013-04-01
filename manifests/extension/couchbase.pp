# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::couchbase { 'couchbase for 5.4.10':
#       version   => '1.1.2'
#       php       => '5.4.10',
#     }
#
define php::extension::couchbase(
  $php,
  $version = '1.1.2'
) {
  require couchbase::lib

  require php::config
  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'couchbase'

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Clone the source repository
  repository { "${php::config::extensioncachedir}/couchbase":
    source => 'couchbase/php-ext-couchbase'
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
    require        => Repository["${php::config::extensioncachedir}/couchbase"],
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}

