# Installs php 5.4.16 and symlinks it as 5.4
#
# Usage:
#
#     include php::5-4
class php::5_4 {
  require php
  require php::5_4_16

  file { "${php::config::root}/versions/5.4":
    ensure  => symlink,
    force   => true,
    target  => "${php::root}/versions/5.4.16"
  }
}
