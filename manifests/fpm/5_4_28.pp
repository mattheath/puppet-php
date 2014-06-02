# Launches a PHP FPM service running PHP 5.4.28
# Installs PHP 5.4.28 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_28
#
class php::fpm::5_4_28 {
  php::fpm { '5.4.28': }
}
