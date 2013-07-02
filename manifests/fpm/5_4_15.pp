# Launches a PHP FPM service running PHP 5.4.15
# Installs PHP 5.4.15 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_15
#
class php::fpm::5_4_15 {
  php::fpm { '5.4.15': }
}
