# Launches a PHP FPM service running PHP 5.3.22
# Installs PHP 5.3.22 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-22
#
class php::fpm::5-3-22 {
  php::fpm { '5.3.22': }
}
