# Launches a PHP FPM service running PHP 5.3.25
# Installs PHP 5.3.25 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_25
#
class php::fpm::5_3_25 {
  php::fpm { '5.3.25': }
}
