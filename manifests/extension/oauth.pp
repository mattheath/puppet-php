# Installs the pecl oauth extension for a specific version of php.
#
# Usage:
#
#     php::extension::oauth { 'oauth for 5.4.10':
#       php     => '5.4.10',
#       version => '1.2.3'
#     }
#
define php::extension::oauth(
  $php,
  $version = '1.2.3'
) {
  require php::config
  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '_')], '::')

  $extension = 'oauth'
  $package_name = "oauth-${version}"
  $url = "http://pecl.php.net/get/oauth-${version}.tgz"

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
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
