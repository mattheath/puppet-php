# Launches a PHP FPM service running PHP 5.3.15
# Installs PHP 5.3.15 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_15
#
class php::fpm::5_3_15 {
  php::fpm { '5.3.15': }
}
