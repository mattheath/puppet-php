# Launches a PHP FPM service running PHP 5.4.6
# Installs PHP 5.4.6 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_6
#
class php::fpm::5_4_6 {
  php::fpm { '5.4.6': }
}
