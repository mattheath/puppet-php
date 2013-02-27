# PHP Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`
* `homebrew`
* `wget`

## Usage

```puppet
# Set the global default php (auto-installs it if it can)
class { 'php::global': version => '5.4.10' }

# ensure a certain php version is used within a dir
php::local { '/path/to/my/awesome/project':
  version => '5.4.9'
}

# install a php version or two
php::version { '5.3.20': }
php::version { '5.4.10': }

# we provide a ton of predefined ones for you though
require php::5-4-10
require php::5-3-17

# Set up PHP-FPM to run a specific version of PHP
php::fpm { '5.4.10': }

# Spin up an FPM pool for a project
# Ensures:
#  * the version of PHP is installed
#  * PHP-FPM is configured as a service
#  * An FPM pool is listening on a per project nginx socket
$name = "project-name"
php::fpm::pool { "${name}-5.4.10":
  version => 5.4.10,
  socket  => "${boxen::config::socketdir}/${name}",
  require => File["${nginx::config::sitesdir}/${name}.conf"],
}

```
