# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::apc { 'apc for 5.4.10':
#       version   => '3.1.13'
#       php       => '5.4.10',
#     }
#
define php::extension::apc(
  $version,
  $php
) {
  require php

  $extension = 'apc'
  $package_name = "APC-${version}"
  $url = "http://pecl.php.net/get/APC-${version}.tgz"

  php_extension { $name:
    extension      => $extension,
    version        => $version,
    package_name   => $package_name,
    package_url    => $url,
    phpenv_root    => $php::config::root,
    php_version    => $php,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php_version}/conf.d/${extension}.ini":
    content  => template("php/extensions/${extension}.ini.erb"),
    requires => Php_extension[$name],
  }

}
