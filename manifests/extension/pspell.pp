# Installs the pspell extension for a specific version of php.
#
# Usage:
#
#     php::extension::pspell { 'pspell for 5.4.10':
#       php => '5.4.10'
#     }
#
define php::extension::pspell(
  $php,
) {
  require php::config

  # Ensure that the specified version of PHP is installed.
  php_require($php)

  $extension = 'pspell'

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-pspell=${boxen::config::homebrewdir}/opt/aspell"

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
