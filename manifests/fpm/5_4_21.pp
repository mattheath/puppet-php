# Launches a PHP FPM service running PHP 5.4.21
# Installs PHP 5.4.21 if it doesn't already exist
#
# Usage:
#
#     include php::fpm::5_4_21
#
class php::fpm::5_4_21 {
  php::fpm { '5.4.21': }
}
