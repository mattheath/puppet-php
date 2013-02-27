# Launches a PHP FPM service running PHP 5.4.8
# Installs PHP 5.4.8 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-4-8
#
class php::fpm::5-4-8 {
  php::fpm { '5.4.8': }
}
