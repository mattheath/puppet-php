# Launches a PHP FPM service running PHP 5.6.0
# Installs PHP 5.6.0 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_6_0
#
class php::fpm::5_6_0 {
  php::fpm { '5.6.0': }
}
