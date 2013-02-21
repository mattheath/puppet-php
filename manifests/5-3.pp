# Installs php 5.3.20 from phpenv and symlinks it as 5.3
#
# Usage:
#
#     include php::5-3
class php::5-3 {
  require php
  require php::5-3-20

  file { "${php::root}/versions/5.3":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/5.3.20"
  }
}
