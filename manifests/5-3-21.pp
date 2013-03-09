# Installs php 5.3.21
#
# Usage:
#
#     include php::5-3-21
class php::5-3-21 {
  php::version { '5.3.21':
    url          => 'http://www.php.net/get/php-5.3.21.tar.bz2/from/this/mirror'
    sha          => 'd67d2569b4782cf2faa049f22b08819ad8b15009'
    brew_version => '5.3.21-boxen1'
  }
}
