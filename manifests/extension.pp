# Installs a php extension for a specific version of php managed by phpenv.
#
# Usage:
#
#     php::extension { 'apc for 5.4.10':
#       extension => 'apc',
#       php       => '5.4.10',
#     }
#
define php::extension($extension, $php) {
  require php

  phpenv_extension { $name:
    extension      => $extension,
    phpenv_root    => $php::config::root,
    phpenv_version => $php,
  }
}
