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
        "PHPENV_ROOT=${php::root}"
      ],
      default => [
        "PHPENV_ROOT=${php::root}",
        "CONFIGURE_OPTS=${conf_opts}"
      ],
    }

    exec { "php-install-${version}":
      command     => "${php::root}/bin/phpenv install php-${version}",
      cwd         => "${php::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
      require     => [
        Exec["ensure-phpenv-version-${php::phpenv_version}"],
        Repository["${php::root}/php-src"]
      ]
    }

    Exec["php-install-${version}"] { environment +> $env }

    if $global {
      file { "${php::root}/version":
        ensure  => present,
        owner   => $::luser,
        mode    => '0644',
        content => "${version}\n",
        require => Exec["php-install-${version}"]
      }
    }

  }
}
