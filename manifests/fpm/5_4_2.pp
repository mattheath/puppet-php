# Launches a PHP FPM service running PHP 5.4.2
# Installs PHP 5.4.2 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_2
#
class php::fpm::5_4_2 {
  php::fpm { '5.4.2': }
}
