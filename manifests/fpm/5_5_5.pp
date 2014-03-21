# Launches a PHP FPM service running PHP 5.5.5
# Installs PHP 5.5.5 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_5
#
class php::fpm::5_5_5 {
  php::fpm { '5.5.5': }
}
