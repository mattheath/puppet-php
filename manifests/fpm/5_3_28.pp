# Launches a PHP FPM service running PHP 5.3.28
# Installs PHP 5.3.28 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_28
#
class php::fpm::5_3_28 {
  php::fpm { '5.3.28': }
}
