# Launches a PHP FPM service running PHP 5.6.4
# Installs PHP 5.6.4 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_6_4
#
class php::fpm::5_6_4 {
  php::fpm { '5.6.4': }
}
