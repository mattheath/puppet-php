class php::config {
  require boxen::config

  $root      = "${boxen::config::home}/phpenv"
  $logdir    = "${boxen::config::logdir}/php"
  $configdir = "${boxen::config::configdir}/php"

  file {
    [
      $root,
      $logdir,
      $configdir,
    ]:
    ensure => directory
  }

}
