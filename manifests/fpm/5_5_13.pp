# Launches a PHP FPM service running PHP 5.5.13
# Installs PHP 5.5.13 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_13
#
class php::fpm::5_5_13 {
  php::fpm { '5.5.13': }
}
