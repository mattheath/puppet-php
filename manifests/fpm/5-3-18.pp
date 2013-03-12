# Launches a PHP FPM service running PHP 5.3.18
# Installs PHP 5.3.18 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-18
#
class php::fpm::5-3-18 {
  php::fpm { '5.3.18': }
}
