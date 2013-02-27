# Launches a PHP FPM service running PHP 5.4.10
# Installs PHP 5.4.10 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5-4-10
class php::fpm::5-4-10 {
  php::fpm { '5.4.10': }
}
