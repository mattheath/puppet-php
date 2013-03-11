# Launches a PHP FPM service running PHP 5.3.1
# Installs PHP 5.3.1 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-1
#
class php::fpm::5-3-1 {
  php::fpm { '5.3.1': }
}
