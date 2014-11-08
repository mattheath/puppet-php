# Base configuration values for PHP
#
# Usage:
#
#     include php::config
#
class php::config(
  $root               = undef,
  $logdir             = undef,
  $configdir          = undef,
  $datadir            = undef,
  $pluginsdir         = undef,
  $cachedir           = undef,
  $extensioncachedir  = undef,
  $configure_params   = undef,
) {
  include boxen::config
}
