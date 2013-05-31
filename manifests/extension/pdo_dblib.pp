# Installs the pdo_dblib extension for a specific version of php.
#
# Usage:
#
#     php::extension::pdo_dblib { 'pdo_dblib for 5.4.10':
#       php       => '5.4.10',
#     }
#
define php::extension::pdo_dblib(
  $php,
) {
  require php::config

  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'pdo_dblib'

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-pdo_dblib=${boxen::config::homebrewdir}/opt/freetds"

  php_extension { $name:
    provider         => php_source,

    extension        => $extension,

    homebrew_path    => $boxen::config::homebrewdir,
    phpenv_root      => $php::config::root,
    php_version      => $php,

    configure_params => $configure_params,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
