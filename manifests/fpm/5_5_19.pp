# Launches a PHP FPM service running PHP 5.5.19
# Installs PHP 5.5.19 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_19
#
class php::fpm::5_5_19 {
  php::fpm { '5.5.19': }
}
