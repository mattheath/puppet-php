# Public: Installs composer globally
#
# Usage:
#
#   include php::composer
#
class php::composer {
  require php

  exec { 'download-php-composer':
    command => "curl -sS -o ${php::config::root}/bin/composer https://getcomposer.org/composer.phar",
    creates => "${php::config::root}/bin/composer",
    cwd     => $php::config::root,
    require => Exec[phpenv-setup-root-repo]
  } ->

  file { "${php::config::root}/bin/composer":
    mode => '0755'
  }
}
