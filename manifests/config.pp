class php::config {
  require boxen::config

  $logdir      = "${boxen::config::logdir}/php"
  $configdir   = "${boxen::config::configdir}/php"

  file {
    [
      $logdir,
      $configdir,
    ]:
    ensure => directory
  }

}
