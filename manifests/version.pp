# Installs a php version via phpenv.

# Options:

#
# Usage:
#
#     php::version { '5.3.20': }
#
define php::version(
  $ensure    = 'installed',
  $global    = false,
  $conf_opts = undef,
  $version   = $name
) {
  require php

  $dest = "${php::root}/versions/php-${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $env = $conf_opts ? {
      undef   => [
        "CC=${cc}",
        "PHPENV_ROOT=${php::root}"
      ],
      default => [
        "CC=${cc}",
        "PHPENV_ROOT=${php::root}",
        "CONFIGURE_OPTS=${conf_opts}"
      ],
    }

    exec { "php-install-${version}":
      command     => "${php::root}/bin/phpenv install php-${version}",
      cwd         => "${php::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest
    }

  }
}
