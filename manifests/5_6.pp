# Installs php 5.6.0 and symlinks it as 5.6
#
# Usage:
#
#     include php::5_6
class php::5_6 {
  require php
  require php::5_6_0

  file { "${php::config::root}/versions/5.6":
    ensure  => symlink,
    force   => true,
    target  => "${php::config::root}/versions/5.6.0"
  }
}
