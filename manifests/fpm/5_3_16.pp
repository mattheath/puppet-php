# Launches a PHP FPM service running PHP 5.3.16
# Installs PHP 5.3.16 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_16
#
class php::fpm::5_3_16 {
  php::fpm { '5.3.16': }
}
