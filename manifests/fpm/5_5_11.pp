# Launches a PHP FPM service running PHP 5.5.11
# Installs PHP 5.5.11 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_11
#
class php::fpm::5_5_11 {
  php::fpm { '5.5.11': }
}
