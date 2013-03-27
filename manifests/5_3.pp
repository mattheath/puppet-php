# Installs php 5.3.20 from phpenv and symlinks it as 5.3
#
# Usage:
#
#     include php::5_3
class php::5_3 {
  require php
  require php::5_3_20

  file { "${php::config::root}/versions/5.3":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/5.3.20"
  }
}
