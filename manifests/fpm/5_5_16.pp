# Launches a PHP FPM service running PHP 5.5.16
# Installs PHP 5.5.16 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_16
#
class php::fpm::5_5_16 {
  php::fpm { '5.5.16': }
}
