# Launches a PHP FPM service running PHP 5.3.2
# Installs PHP 5.3.2 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-3-2
#
class php::fpm::5-3-2 {
  php::fpm { '5.3.2': }
}
