# Launches a PHP FPM service running PHP 5.4.18
# Installs PHP 5.4.18 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_18
#
class php::fpm::5_4_18 {
  php::fpm { '5.4.18': }
}
