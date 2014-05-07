# Public: Installs composer globally
#
# Usage:
#
#   include php::composer
#
class php::composer {
  require php

  exec { 'download-php-composer':
    command => "curl -sS -o ${php::config::root}/bin/composer https://getcomposer.org/download/1.0.0-alpha8/composer.phar",
    unless  => "[ -f ${php::config::root}/bin/composer ] && [ \"`md5 -q ${php::config::root}/bin/composer`\" = \"df1001975035f07d09307bf1f1e62584\" ]",
    cwd     => $php::config::root,
    require => Exec['phpenv-setup-root-repo']
  } ->

  file { "${php::config::root}/bin/composer":
    mode => '0755'
  }
}
