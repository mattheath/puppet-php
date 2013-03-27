# Launches a PHP FPM service running PHP 5.3.14
# Installs PHP 5.3.14 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_14
#
class php::fpm::5_3_14 {
  php::fpm { '5.3.14': }
}
