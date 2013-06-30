# Installs the imagick extension for a specific version of php.
#
# Usage:
#
#     php::extension::imagick { 'imagick for 5.4.10':
#       php       => '5.4.10',
#       imagick   => '3.0.0RC1'
#     }
#
define php::extension::imagick(
  $php,
  $version = '3.0.0'
) {
  require php::config
  require imagemagick

  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'imagick'
  $package_name = "imagick-${version}"
  $url = "http://pecl.php.net/get/imagick-${version}.tgz"

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-imagick=${boxen::config::homebrewdir}/opt/imagemagick"

  php_extension { $name:
    extension      => $extension,
    version        => $version,
    package_name   => $package_name,
    package_url    => $url,
    homebrew_path  => $boxen::config::homebrewdir,
    phpenv_root    => $php::config::root,
    php_version    => $php,
    configure_params => $configure_params,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
