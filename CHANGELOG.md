## 0.5.1 ##

* Partial fix for zlib dependency issues - the module now installs a custom `zlib` brew as the package `zlibphp`
* Fixes #20 - PHP-FPM not building on PHP versions 5.3.2* eg. 5.3.20

## 0.5.0 ##

* Allow for customization of PHP-FPM pool configuration, thanks @enthooz!
* Consume `$server_name` variable in Nginx config template (@enthooz)
* Refactor all PHP version & FPM classes to meet coding standards. This unfortunately breaks backwards compatibility by changing version classes such as `php::5-3-20` to `php::5_3_20`, and `php::fpm::5-3-20` to `php::fpm::5_3_20`
* Rename the `socket` parameter in the `php::fpm::pool` class to `socket_path` to prevent clashing with global variables, and is no longer optional
* No longer attempt to build PHP-FPM for versions < `5.3.3`
* Minor bug fixes
* Travis integration!

## 0.4.2 ##

* Refresh a PHP-FPM service when a FPM pool config file changes, #15

## 0.4.1 ##

* Add intl extension
* Fix PEAR temp_dir permission issue
* Add PHP versions 5.3.22 & 5.3.23, #12 - thanks @webflo
* Documentation improvements

## 0.4.0 ##

* Module is now reasonably stable!
* Add php::project manifest
* Document using PHP-FPM pools with PHP projects

## 0.3.8 ##

* Improve PHP installation process
* Ensure dependencies are defined in the correct orders
* Fix dependency paths which were not fully qualified when building PHP and extensions
* Remove & reinstall failed builds
* Ensure that PHP binaries exist once a version is installed

## 0.3.7 ##

* List PCRE as a dependency which PEAR compilation fails without

## 0.3.6 ##

* Fix file permissions when installing PHP
* Fix file permissions on versions installed prior to this fix
* Configure PEAR cache and download folders fixing most PEAR errors

## 0.3.5 ##

* Add `pkgconfig` as a dependency - required for some extensions

## 0.3.4 ##

* Fix dependency error causing installation to fail

## 0.3.3 ##

* Minor bug fixes to improve reliability of installation

## 0.3.2 ##

* Add git extension provider - install PHP extensions from a git repository
* Add zeromq extension

## 0.3.1 ##

* Minor bug fixes

## 0.3.0 ##

* Add custom provider to install PHP extensions from PECL
* Add remaining versions of PHP to be installed
* Add APC, HTTP, Memcached & Zookeeper extension classes
* Add example nginx config template - this (or similar) should be used for PHP based projects

## 0.2.0 ##

* Complete rebuild of PHP installation method, making the process _significantly_ more reliable
* Remove php-build and replace with custom Puppet provider
* Fix issues with different autoconf requirements for PHP 5.3 and 5.4

## 0.1.2 ##

* Fix incorrect php.ini load path
* Minor bug fixes

## 0.1.1 ##

* Bug fixes
* Fix missing dependencies
* Fix nginx fastcgi params

## 0.1.0 ##

* Add PHP-FPM functionality
* Allow multiple FPM services to be run in parallel
* Multiple FPM pools per FPM service, listening on per project nginx sockets
* Correct Log and Config paths to be in Boxen locations

## 0.0.1 ##

* Install PHPenv
* Use php-build to install PHP versions
* Install multiple versions of PHP side by side
