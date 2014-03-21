# Launches a PHP FPM service running PHP 5.5.10
# Installs PHP 5.5.10 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_10
#
class php::fpm::5_5_10 {
  php::fpm { '5.5.10': }
}
