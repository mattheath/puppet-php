# Launches a PHP FPM service running PHP 5.3.23
# Installs PHP 5.3.23 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-23
#
class php::fpm::5-3-23 {
  php::fpm { '5.3.23': }
}
