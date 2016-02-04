# Installs a php version, and sets up phpenv
#
# Usage:
#
#     php::version { '5.3.20': }
#
define php::version(
  $ensure   = 'installed',
  $version  = $name
) {
  require php
  include mysql::config

  # Current supported and secure versions
  $secure_5_6 = $php::config::secure_versions['5.6']
  $secure_5_5 = $php::config::secure_versions['5.5']
  $secure_5_4 = $php::config::secure_versions['5.4']

  # Specify secure version if no minor point specified
  if $version == '5' {
    $patch_version = $secure_5_6
  } elsif $version == '5.6' {
    $patch_version = $secure_5_6
  } elsif $version == '5.5' {
    $patch_version = $secure_5_5
  } elsif $version == '5.4' {
    $patch_version = $secure_5_4
  } else {
    $patch_version = $version
  }

  # Version is greater than or equal to 5.6.0 and less than the 5.6 secure version
  if $php::config::secure_warning and versioncmp($patch_version, '5.6') >= 0 and versioncmp($patch_version, $secure_5_6) < 0 {
    warning("You are installing PHP ${patch_version} which is known to be insecure. The current secure 5.6.X version is ${secure_5_6}")
  }

  # Version is greater than or equal to 5.5.0 and less than the 5.5 secure version
  if $php::config::secure_warning and versioncmp($patch_version, '5.5') >= 0 and versioncmp($patch_version, $secure_5_5) < 0 {
    warning("You are installing PHP ${patch_version} which is known to be insecure. The current secure 5.5.X version is ${secure_5_5}")
  }

  # Version is less than the minimum secure version
  if $php::config::secure_warning and versioncmp($patch_version, $secure_5_4) < 0 {
    warning("You are installing PHP ${patch_version} which is known to be insecure. The current secure 5.4.X version is ${secure_5_4}")
  }

  # Install location
  $dest = "${php::config::root}/versions/${patch_version}"

  # Log locations
  $error_log = "${php::config::logdir}/${patch_version}.error.log"

  # Config locations
  $version_config_root  = "${php::config::configdir}/${patch_version}"
  $php_ini              = "${version_config_root}/php.ini"
  $conf_d               = "${version_config_root}/conf.d"

  # Module location for PHP extensions
  $module_dir = "${dest}/modules"

  # Data directory for this version
  $version_data_root = "${php::config::datadir}/${patch_version}"

  if $ensure == 'absent' {

    # If we're nuking a version of PHP also ensure we shut down
    # and get rid of the PHP FPM Service & config

    php::fpm { $patch_version:
      ensure => 'absent'
    }

    file {
      [
        $dest,
        $version_config_root,
        $version_data_root,
      ]:
      ensure => absent,
      force  => true
    }

  } else {

    # Data directory
    file { $version_data_root:
      ensure => directory,
    }

    # Set up config directories
    file { $version_config_root:
      ensure => directory,
    }

    file { $conf_d:
      ensure  => directory,
      purge   => true,
      force   => true,
      require => File[$version_config_root],
    }

    # Ensure module dir is created for extensions AFTER php is installed
    file { $module_dir:
      ensure  => directory,
      require => Php_version[$patch_version],
    }

    # Set up config files
    file { $php_ini:
      content => template('php/php.ini.erb'),
      require => File[$version_config_root]
    }

    # Log files
    file { $error_log:
      owner => $::boxen_user,
      mode  => '0644',
    }

    # Install PHP!

    # Get any additional configure params
    $test_params = $php::config::configure_params
    if is_hash($test_params) and has_key($test_params, $patch_version) {
      $configure_params = $test_params[$patch_version]
    }

    php_version { $patch_version:
      user              => $::boxen_user,
      user_home         => "/Users/${::boxen_user}",
      phpenv_root       => $php::config::root,
      version           => $patch_version,
      homebrew_path     => $boxen::config::homebrewdir,
      require           => [
        Repository["${php::config::root}/php-src"],
        Package['gettext'],
        Package['boxen/brews/freetypephp'],
        Package['gmp'],
        Package['icu4c'],
        Package['jpeg'],
        Package['libpng'],
        Package['mcrypt'],
        Package['boxen/brews/zlibphp'],
        Package['autoconf'],
        Package['boxen/brews/autoconf213'],
      ],
      notify            => Exec["phpenv-rehash-post-install-${patch_version}"],
      configure_params  => $configure_params,
    }

    # Fix permissions for php versions installed prior to 0.3.5 of this module
    file { $dest:
      ensure  => directory,
      owner   => $::boxen_user,
      group   => 'staff',
      recurse => true,
      require => Php_version[$patch_version],
    }

    # Rehash phpenv shims when a new version is installed
    exec { "phpenv-rehash-post-install-${patch_version}":
      command     => "/bin/rm -rf ${php::config::root}/shims && PHPENV_ROOT=${php::config::root} ${php::config::root}/bin/phpenv rehash",
      require     => Php_version[$patch_version],
      refreshonly => true,
    }

    # PEAR cruft

    # Ensure per version PEAR cache folder is present
    file { "${version_data_root}/cache":
      ensure  => directory,
      require => File[$version_data_root],
    }

    # Set cache_dir for PEAR
    exec { "pear-${patch_version}-cache_dir":
      command => "${dest}/bin/pear config-set cache_dir ${php::config::datadir}/pear",
      unless  => "${dest}/bin/pear config-get cache_dir | grep -i ${php::config::datadir}/pear",
      require => [
        Php_version[$patch_version],
        File["${php::config::datadir}/pear"],
      ],
    }

    # Set download_dir for PEAR
    exec { "pear-${patch_version}-download_dir":
      command => "${dest}/bin/pear config-set download_dir ${php::config::datadir}/pear",
      unless  => "${dest}/bin/pear config-get download_dir | grep -i ${php::config::datadir}/pear",
      require => [
        Php_version[$patch_version],
        File["${php::config::datadir}/pear"],
      ],
    }

    # Set temp_dir for PEAR
    exec { "pear-${patch_version}-temp_dir":
      command => "${dest}/bin/pear config-set temp_dir ${php::config::datadir}/pear",
      unless  => "${dest}/bin/pear config-get temp_dir | grep -i ${php::config::datadir}/pear",
      require => [
        Php_version[$patch_version],
        File["${php::config::datadir}/pear"],
      ],
    }

  }
}
