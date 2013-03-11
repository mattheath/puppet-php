# Installs a php extension for a specific version of php.
#
# Usage:
#
#     php::extension::apc { 'apc for 5.4.10':
#       version   => '3.1.13'
#       php       => '5.4.10',
#     }
#
define php::extension::memcached(
  $version = '2.1.0',
  $php
) {
  include boxen::config
  require php
  require memcached::lib

  $extension = 'memcached'
  $package_name = "memcached-${version}"
  $url = "http://pecl.php.net/get/memcached-${version}.tgz"

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-libmemcached-dir=${boxen::config::homebrewdir}/opt/libmemcached"

  php_extension { $name:
    extension      => $extension,
    version        => $version,
    package_name   => $package_name,
    package_url    => $url,
    phpenv_root    => $php::config::root,
    php_version    => $php,
    cache_dir      => $php::config::extensioncachedir,
    configure_params => $configure_params,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template("php/extensions/${extension}.ini.erb"),
    require => Php_extension[$name],
  }

}
