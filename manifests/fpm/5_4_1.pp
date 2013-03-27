# Launches a PHP FPM service running PHP 5.4.1
# Installs PHP 5.4.1 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_1
#
class php::fpm::5_4_1 {
  php::fpm { '5.4.1': }
}
