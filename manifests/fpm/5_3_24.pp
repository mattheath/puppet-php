# Launches a PHP FPM service running PHP 5.3.24
# Installs PHP 5.3.24 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_3_24
#
class php::fpm::5_3_24 {
  php::fpm { '5.3.24': }
}
