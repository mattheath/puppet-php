# Launches a PHP FPM service running PHP 5.6.3
# Installs PHP 5.6.3 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_6_3
#
class php::fpm::5_6_3 {
  php::fpm { '5.6.3': }
}
