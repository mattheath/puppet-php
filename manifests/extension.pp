# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension { 'apc for 5.4.10':
#       extension => 'apc',
#       version   => '3.1.13'
#       php       => '5.4.10',
#     }
#
define php::extension(
  $extension,
  $version,
  $php
) {
  require php

  php_extension { $name:
    extension      => $extension,
    version        => $version,
    phpenv_root    => $php::config::root,
    phpenv_version => $php,
  }

  # Cache source code repository

}
