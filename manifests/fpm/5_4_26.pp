# Launches a PHP FPM service running PHP 5.4.26
# Installs PHP 5.4.26 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_26
#
class php::fpm::5_4_26 {
  php::fpm { '5.4.26': }
}
