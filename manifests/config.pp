class php::config {
  require boxen::config

  $root       = "${boxen::config::home}/phpenv"
  $logdir     = "${boxen::config::logdir}/php"
  $configdir  = "${boxen::config::configdir}/php"
  $datadir    = "${boxen::config::datadir}/php"
  $pluginsdir = "${root}/plugins"

  file {
    [
      $root,
      $logdir,
      $datadir,
      $pluginsdir,
    ]:
    ensure => directory
  }

  # Ensure we only have config files managed by Boxen
  # to prevent any conflicts by shipping a (nearly) empty
  # dir, and recursively purging
  file { $configdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    source => "puppet:///modules/php/empty-conf-dir",
  }

}
