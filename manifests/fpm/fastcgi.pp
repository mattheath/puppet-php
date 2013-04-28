# Adds FastCGI configuration parameters to $webserver which is
# required to use PHP-FPM
#
# Usage:
#
#   include php::fpm::fastcgi
#
class php::fpm::fastcgi {
  $webserver_class = "php::fpm::webserver::${php::config::webserver}"
  include $webserver_class
}
