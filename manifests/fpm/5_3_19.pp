# Launches a PHP FPM service running PHP 5.3.19
# Installs PHP 5.3.19 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_19
#
class php::fpm::5_3_19 {
  php::fpm { '5.3.19': }
}
