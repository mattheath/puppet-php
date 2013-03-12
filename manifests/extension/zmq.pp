# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::zmq { 'zmq for 5.4.10':
#       version   => '1.0.5'
#       php       => '5.4.10',
#     }
#
define php::extension::zmq(
  $version = '1.0.5',
  $php
) {
  require php
  require zeromq

  $extension = 'zmq'

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Clone the source repository
  repository { "${php::config::extensioncachedir}/zmq":
    source => 'mkoppanen/php-zmq'
  }

  # Build & install the extension
  php_extension { $name:
    provider       => 'git',

    extension      => $extension,
    version        => $version,

    phpenv_root    => $php::config::root,
    php_version    => $php,

    cache_dir      => $php::config::extensioncachedir,
    require        => Repository["${php::config::extensioncachedir}/zmq"],
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template("php/extensions/${extension}.ini.erb"),
    require => Php_extension[$name],
  }

}
