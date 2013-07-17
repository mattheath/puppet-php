# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::apc { 'apc for 5.4.10':
#       version   => '3.1.13'
#       php       => '5.4.10',
#     }
#
class imagemagick {
  include homebrew

  package { 'imagemagick': }
}


define php::extension::imagick(
  $version = '3.0.1',
  $php
) {
  require php::config
  # Require php version eg. php::5-4-10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')
  include imagemagick

  $extension = 'imagick'
  $package_name = "imagick-${version}"
  $url = "http://pecl.php.net/get/imagick-${version}.tgz"

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  php_extension { $name:
    extension      => $extension,
    version        => $version,
    package_name   => $package_name,
    package_url    => $url,
    homebrew_path  => $boxen::config::homebrewdir,
    phpenv_root    => $php::config::root,
    php_version    => $php,
    cache_dir      => $php::config::extensioncachedir,
	configure_params => "--with-imagick=${boxen::config::homebrewdir}", # we need this under OSXs
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template("php/extensions/generic.ini.erb"),
    require => Php_extension[$name],
  }

}
