# Public: specify the global php version for phpenv
#
# Usage:
#
#   class { 'php::global': version => '5.4.10' }

class php::global($version = undef) {
  include php::config

  # Default to HEAD 5.4 version if not specified
  $php_version = $version ? {
    undef   => 5.4,
    default => $version
  }

  if $version != 'system' {
    require join(['php', join(split($version, '[.]'), '_')], '::')
  }

  file { "${php::config::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
