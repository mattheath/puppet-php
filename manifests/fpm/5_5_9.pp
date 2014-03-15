# Launches a PHP FPM service running PHP 5.5.9
# Installs PHP 5.5.9 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_5_9
#
class php::fpm::5_5_9 {
  php::fpm { '5.5.9': }
}
