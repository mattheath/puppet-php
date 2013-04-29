# Launches a PHP FPM service running PHP 5.4.14
# Installs PHP 5.4.14 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_14
#
class php::fpm::5_4_14 {
  php::fpm { '5.4.14': }
}
