# Launches a PHP FPM service running PHP 5.5.0
# Installs PHP 5.5.0 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_0
#
class php::fpm::5_5_0 {
  php::fpm { '5.5.0': }
}
