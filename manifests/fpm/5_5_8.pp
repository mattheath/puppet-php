# Launches a PHP FPM service running PHP 5.5.8
# Installs PHP 5.5.8 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_8
#
class php::fpm::5_5_8 {
  php::fpm { '5.5.8': }
}
