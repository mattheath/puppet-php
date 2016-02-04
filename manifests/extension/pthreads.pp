# Installs the pthreads extension for a specific version of php.
#
# Requires PHP to be built with thread safety, add:
#
#     php::config::configure_params:
#       5.5.18: '--enable-maintainer-zts'
#
# or similar to Hiera configs in your Boxen repo (adjust for your version).
#
# Usage:
#
#     php::extension::pthreads { 'pthreads for 5.5.18':
#       php     => '5.5.18',
#       version => '2.0.10'
#     }
#
define php::extension::pthreads(
  $php,
  $version = '2.0.10',
) {
  require php::config

  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  php_require($php)

  $extension = 'pthreads'
  $package_name = "pthreads-${version}"
  $url = "http://pecl.php.net/get/pthreads-${version}.tgz"

  # Final module install path
  $module_path = "${php::config::root}/versions/${php}/modules/${extension}.so"

  php_extension { $name:
    extension        => $extension,
    version          => $version,
    package_name     => $package_name,
    package_url      => $url,
    homebrew_path    => $boxen::config::homebrewdir,
    phpenv_root      => $php::config::root,
    php_version      => $php,
    provider         => pecl,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${php}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
