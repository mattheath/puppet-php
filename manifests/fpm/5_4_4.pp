# Launches a PHP FPM service running PHP 5.4.4
# Installs PHP 5.4.4 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_4
#
class php::fpm::5_4_4 {
  php::fpm { '5.4.4': }
}
