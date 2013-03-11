# Launches a PHP FPM service running PHP 5.4.7
# Installs PHP 5.4.7 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-4-7
#
class php::fpm::5-4-7 {
  php::fpm { '5.4.7': }
}
