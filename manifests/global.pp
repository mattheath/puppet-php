# Public: specify the global php version as per phpenv
#
# Usage:
#
#   class { 'php::global': version => '5.4.10' }

class php::global($version) {
  require php

  if $version != 'system' {
    require join(['php', join(split($version, '[.]'), '-')], '::')
  }

  file { "${php::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
