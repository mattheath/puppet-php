# Launches a PHP FPM service running PHP 5.3.11
# Installs PHP 5.3.11 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-11
#
class php::fpm::5-3-11 {
  php::fpm { '5.3.11': }
}
