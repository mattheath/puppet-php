# Launches a PHP FPM service running PHP 5.4.12
# Installs PHP 5.4.12 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_12
#
class php::fpm::5_4_12 {
  php::fpm { '5.4.12': }
}
