# PHP Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`
* `homebrew`
* `wget`
* `autoconf`
* `libtool`

## Usage

```puppet
# Install php 5.4
require php::5-4

# Install a couple of specific minor versions
require php::5-3-17
require php::5-4-11

# Install a php version and set as the global default php
class { 'php::global':
  version => '5.4.10'
}

# Ensure a specific php version is used within a directory
php::local { '/path/to/my/awesome/project':
  version => '5.4.9'
}

# Ensure an extension is installed for a certain php version
# note, you can't have duplicate resource names so you have to name like so
php::extension::apc { "apc for ${version}":
  php     => $version,
  version => '3.1.13', # Optionally specify the extension version
}

# Set up PHP-FPM as a service running a specific version of PHP
php::fpm { '5.4.10': }

# Spin up a PHP-FPM pool for a project
# Ensures:
#  * the version of PHP is installed
#  * a PHP-FPM service is configured for this PHP version
#  * a FPM pool is listening on a per project nginx socket
$name = "project-name"
php::fpm::pool { "${name}-5.4.10":
  version => 5.4.10,
  socket  => "${boxen::config::socketdir}/${name}",
  require => File["${nginx::config::sitesdir}/${name}.conf"],
}

```
