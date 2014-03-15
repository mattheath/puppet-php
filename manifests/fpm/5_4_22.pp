# Launches a PHP FPM service running PHP 5.4.22
# Installs PHP 5.4.22 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_22
#
class php::fpm::5_4_22 {
  php::fpm { '5.4.22': }
}
