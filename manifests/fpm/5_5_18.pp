# Launches a PHP FPM service running PHP 5.5.18
# Installs PHP 5.5.18 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_18
#
class php::fpm::5_5_18 {
  php::fpm { '5.5.18': }
}
