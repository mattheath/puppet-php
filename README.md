# PHP Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-php.png?branch=master)](https://travis-ci.org/boxen/puppet-php)

Requires the following boxen modules:

* `boxen`
* `homebrew`
* `stdlib`
* `wget`
* `autoconf`
* `libtool`
* `pkgconfig`
* `pcre`
* `libpng`
* `mysql`

The following boxen modules are required if optional PHP extensions are used:

* `couchbase` ([SocalNick/puppet-couchbase](https://github.com/SocalNick/puppet-couchbase)) - Couchbase extension `php::extension::couchbase`
* `imagemagick` - Imagemagick extension `php::extension::imagick`
* `redis` - Redis extension `php::extension::redis`

## Usage

```puppet
# Install php 5.4
php::version { '5.4': }

# Install a couple of specific minor versions
php::version { '5.3.17': }
php::version { '5.4.11': }

# Install Composer globally on your PATH
include php::composer

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
php::fpm { '5.3.15': }

# Run multiple PHP-FPM services
php::fpm { '5.4.11': }
php::fpm { '5.3.23': }

# Spin up a PHP-FPM pool for a project
# Ensures:
#  * the version of PHP is installed
#  * a PHP-FPM service is configured for this PHP version
#  * a FPM pool is listening on a per project nginx socket
$name = "project-name"
$version = "5.4.10"
php::fpm::pool { "${name}-${version}":
  version     => $version,
  socket_path => "${boxen::config::socketdir}/${name}",
  require     => File["${nginx::config::sitesdir}/${name}.conf"],
}

```

## PHP Project Usage ##

A sample PHP project manifest is provided in `manifests/project.pp` which will run a PHP project using PHP-FPM under Nginx. This can be used directly, but may require tweaking for your own purposes.

A simple project manifest example:

```puppet
# your-boxen/modules/projects/manifests/trollin.pp

class projects::trollin {

  php::project { 'trollin':
    source        => 'boxen/trollin',
    elasticsearch => true,
    mysql         => true,
    nginx         => 'php/nginx/nginx.conf.erb',
    redis         => true,
    php           => '5.3.23',
  }
}
```

With the above, as long as our app is configured to listen to requests at `www/index.php` we can visit [http://trollin.dev/](http://trollin.dev/) to access the app.

In the background this is installing PHP 5.3.23, creating a PHP-FPM service for 5.3.23, and a FPM pool for this project which runs within the FPM service. This then listens on an nginx socket at "#{ENV['BOXEN_SOCKET_DIR']}"/trollin.

The example nginx host template at `templates/nginx/nginx.conf.erb` is also a sample configuration which can be copied to your main boxen module and the nginx template path above altered to match this. This is set up with a basic PHP structure, and Fastcgi params to pass the expected variables from Nginx to PHP-FPM.

## Upgrading to version 2.X.X from version 1.X.X

The old PHP version classes are removed completely in version 2.

You will need to change any code in your manifests like `include PHP::5_X_X` to the version 2 equivalent `php::version { 5.X.X: }`

All other classes remain unchanged in syntax, and should "just work".

This module will now warn you if you are running an insecure version of PHP when you run Boxen.
