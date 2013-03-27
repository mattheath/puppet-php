# Launches a PHP FPM service running PHP 5.4.5
# Installs PHP 5.4.5 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_5
#
class php::fpm::5_4_5 {
  php::fpm { '5.4.5': }
}
