# Installs a php version via php-build, and sets up phpenv

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
  require wget
  require php
  require php::php_build

  $dest = "${php::root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {

    exec { "php-install-${version}":
      command     => "${php::php_build::root}/bin/php-build ${version} ${php::root}/versions/${version}",
      cwd         => "${php::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
    }

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
