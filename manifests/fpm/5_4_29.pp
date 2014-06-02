# Launches a PHP FPM service running PHP 5.4.29
# Installs PHP 5.4.29 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_29
#
class php::fpm::5_4_29 {
  php::fpm { '5.4.29': }
}
