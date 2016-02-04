# Public: specify the global php version for phpenv
#
# Usage:
#
#   class { 'php::global': version => '5.4.10' }
#
class php::global($version = undef) {
  include php::config

  # Default to latest version of PHP 5 if not specified
  $php_version = $version ? {
    undef   => 5,
    default => $version
  }

  if $version != 'system' {
    php_require($version)
  }

  file { "${php::config::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
