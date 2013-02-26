class php::config {
  require boxen::config

  $root       = "${boxen::config::home}/phpenv"
  $logdir     = "${boxen::config::logdir}/php"
  $configdir  = "${boxen::config::configdir}/php"
  $pluginsdir = "${root}/plugins"

  file {
    [
      $root,
      $logdir,
      $configdir,
      $pluginsdir,
    ]:
    ensure => directory
  }

}
