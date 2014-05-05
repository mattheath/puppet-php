# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::xhprof { 'xhprof for 5.4.10':
#       php     => '5.4.10',
#       version => '0.9.4'
#     }
#
define php::extension::xhprof(
  $php,
  $version = '0.9.4',
  $config_template = "php/extensions/xhprof.ini.erb"
) {
  require php::config
  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'xhprof'
  $package_name = "xhprof-${version}"
  $url = "http://pecl.php.net/get/xhprof-${version}.tgz"

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
    extension_dir  => 'extension'
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template($config_template),
    require => Php_extension[$name],
  }

}
