# Installs php 5.3.26 and symlinks it as 5.3
#
# Usage:
#
#     include php::5_3
class php::5_3 {
  require php
  require php::5_3_26

  file { "${php::config::root}/versions/5.3":
    ensure  => symlink,
    force   => true,
    target  => "${php::config::root}/versions/5.3.26"
  }
}
