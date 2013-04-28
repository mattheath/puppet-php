# Launches a PHP FPM service running PHP 5.4.13
# Installs PHP 5.4.13 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_13
#
class php::fpm::5_4_13 {
  php::fpm { '5.4.13': }
}
