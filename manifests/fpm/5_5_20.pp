# Launches a PHP FPM service running PHP 5.5.20
# Installs PHP 5.5.20 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_20
#
class php::fpm::5_5_20 {
  php::fpm { '5.5.20': }
}
