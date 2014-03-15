# Launches a PHP FPM service running PHP 5.4.23
# Installs PHP 5.4.23 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_23
#
class php::fpm::5_4_23 {
  php::fpm { '5.4.23': }
}
