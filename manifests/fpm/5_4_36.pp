# Launches a PHP FPM service running PHP 5.4.36
# Installs PHP 5.4.36 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_36
#
class php::fpm::5_4_36 {
  php::fpm { '5.4.36': }
}
