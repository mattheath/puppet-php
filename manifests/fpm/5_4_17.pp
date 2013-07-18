# Launches a PHP FPM service running PHP 5.4.17
# Installs PHP 5.4.17 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_17
#
class php::fpm::5_4_17 {
  php::fpm { '5.4.17': }
}
