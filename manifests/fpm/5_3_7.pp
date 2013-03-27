# Launches a PHP FPM service running PHP 5.3.7
# Installs PHP 5.3.7 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_7
#
class php::fpm::5_3_7 {
  php::fpm { '5.3.7': }
}
