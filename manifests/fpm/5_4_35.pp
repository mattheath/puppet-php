# Launches a PHP FPM service running PHP 5.4.35
# Installs PHP 5.4.35 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_35
#
class php::fpm::5_4_35 {
  php::fpm { '5.4.35': }
}
