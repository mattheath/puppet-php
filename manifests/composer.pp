# Public: Installs composer globally
#
# Usage:
#
#   include php::composer
#
class php::composer {
  require php

  exec { 'download-php-composer':
    command => 'curl -sS https://getcomposer.org/installer | /usr/bin/php -d detect_unicode=Off',
    creates => "${php::config::root}/composer.phar",
    cwd     => $php::config::root,
    require => Exec[phpenv-setup-root-repo]
  } ->

  file { "${php::config::root}/composer.phar":
    mode => '0755'
  } ->

  file { "${php::config::root}/bin/composer":
    ensure => link,
    target => "${php::config::root}/composer.phar"
  }
}
