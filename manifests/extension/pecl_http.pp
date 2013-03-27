# Installs the pecl_http extension for a specific version of php.
#
# Usage:
#
#     php::extension::pecl_http { 'http for 5.4.10':
#       version   => '1.7.5'
#       php       => '5.4.10',
#     }
#
define php::extension::pecl_http(
  $php,
  $version = '1.7.5'
) {
  include boxen::config
  require zookeeper

  require php::config
  # Require php version eg. php::5-4-10
  # This will compile, install and set up config dirs if not present
  require join(['php', join(split($php, '[.]'), '-')], '::')

  $extension = 'pecl_http'
  $package_name = "pecl_http-${version}"
  $url = "http://pecl.php.net/get/pecl_http-${version}.tgz"

  # Final module name & install path
  $compiled_name = 'http.so'
  $module_path = "${php::config::root}/versions/${php}/modules/${compiled_name}"

  php_extension { $name:
    extension        => $extension,
    version          => $version,
    package_name     => $package_name,
    package_url      => $url,
    homebrew_path    => $boxen::config::homebrewdir,
    phpenv_root      => $php::config::root,
    php_version      => $php,
    cache_dir        => $php::config::extensioncachedir,
    compiled_name    => $compiled_name,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template("php/extensions/${extension}.ini.erb"),
    require => Php_extension[$name],
  }

}
