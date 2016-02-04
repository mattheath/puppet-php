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
  $composer           = undef,
  $phpenv             = undef,
  $secure_versions    = undef,
  $secure_warning     = undef,
) {
  include boxen::config

  validate_string(
    $root,
    $logdir,
    $configdir,
    $datadir,
    $pluginsdir,
    $cachedir,
    $extensioncachedir,
  )

  validate_hash(
    $configure_params,
    $composer,
    $phpenv,
    $secure_versions,
  )

  validate_bool(
    $secure_warning,
  )
}
