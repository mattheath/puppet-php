# Launches a PHP FPM service running PHP 5.4.27
# Installs PHP 5.4.27 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_27
#
class php::fpm::5_4_27 {
  php::fpm { '5.4.27': }
}
