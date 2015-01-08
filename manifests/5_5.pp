# Installs php 5.5.0 and symlinks it as 5.5
#
# Usage:
#
#     include php::5_5
#
class php::5_5 {
  require php
  require php::5_5_0

  file { "${php::config::root}/versions/5.5":
    ensure  => symlink,
    force   => true,
    target  => "${php::config::root}/versions/5.5.0"
  }
}
