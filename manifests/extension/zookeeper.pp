# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::apc { 'apc for 5.4.10':
#       version   => '3.1.13'
#       php       => '5.4.10',
#     }
#
define php::extension::zookeeper(
  $php,
  $version = '0.2.1'
) {
  include boxen::config
  require zookeeper

  require php::config
  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'zookeeper'
  $package_name = "zookeeper-${version}"
  $url = "http://pecl.php.net/get/zookeeper-${version}.tgz"

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-libzookeeper-dir=${boxen::config::homebrewdir}/opt/zookeeper"

  php_extension { $name:
    extension        => $extension,
    version          => $version,
    package_name     => $package_name,
    package_url      => $url,
    homebrew_path    => $boxen::config::homebrewdir,
    phpenv_root      => $php::config::root,
    php_version      => $php,
    cache_dir        => $php::config::extensioncachedir,
    configure_params => $configure_params,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template("php/extensions/${extension}.ini.erb"),
    require => Php_extension[$name],
  }

}
