## 2.0.0 ##

* Use Hiera for configs
* Allow configure params on PHP builds
* Add PThreads extension
* Update cardboard to 2.1.0 and update tests
* Add support for PHP 5.6+
* Add insecure PHP version warnings
* Make Composer version configurable
* Remove version specific PHP classes allowing arbitrary PHP versions

## 1.2.6 ##

* Fix autoconf 2.13 sandboxing

## 1.2.5 ##

* Sandbox autoconf213 to fix some installation conflicts
* Set the PECL provider to default on darwin for PHP extensions (this can be overridden)
* Increase `pm.max_children` to 10 for PHP-FPM pools (@gblair)

## 1.2.4 ##

* Fixes compilation of PHP versions > 5.4.17 due to a break in Bison compatibility (@webflo!)

## 1.2.3 ##

* Add xhprof extension (@webflo)
* Add latest versions of PHP 5.4 and 5.5 (@webflo)

## 1.2.2 ##

* Change default .ini settings to increase timeouts, memory limits etc.

## 1.2.1 ##

* Bump Composer to latest 1.0.0-alpha8 (@webbj74)

## 1.2.0 ##

* Adds PHP 5.5 support! This requires a later version of Bison to compile, which is installed as a sandboxed package.
* Adds additional minor versions of PHP for 5.3 and 5.4
* Use ensure_packages from the stdlib to improve module compatibility (thanks @jameydeorio)
* Fixes specs, and added Github API token to travis so builds actually work again

## 1.1.5 ##

* Add OAuth extension (@dbtlr)
* Fix HTTP extension bug including zookeeper (@dbtlr)
* Add Mongo extension (@eebs)
* Fix compilation bug caused by Freetype and GD incompatibilities (@eebs!)

## 1.1.4 ##

* Add memcache PHP extension (@poppen)
* Add pdo_pgsql PHP extension (@poppen)

## 1.1.3 ##

* Added support for Composer see the readme for usage.
* Module now has test specs (hooray!), please run script/cibuild before making a pull request.
* Fixes to bugs the specs caught

## 1.1.2 ##

* Increase xdebug `max_nesting_level`

## 1.1.1 ##

* Remove `libpng` package, add dependency on `libpng` module

## 1.1.0 ##

* Add couchbase extension (@SocalNick)
* Add redis extension (@b00giZm)
* Add imagemagick extension (@phindmarsh)
* Fix styling bugs so lint checks pass
* Add lastest PHP versions - 5.3.25, 5.3.26, 5.4.15, 5.4.16, 5.4.17
* Fix bug where major version classes (php::5_4) were symlinked to the wrong place

## 1.0.0 ##

* Add mssql php extension (@blackjid)
* Version 1.0.0!

## 0.5.7 ##

* Add MIT License
* Stop PHPEnv rehashing on every Boxen run, #6
* Fix incorrectly declared class path, #6

## 0.5.6 ##

* Fix external zlib issue caused by 1.2.7 being removed from source by upgrading to version 1.2.8 (thanks @hughevans). This unfortunately breaks previously installed versions, however this is fixed by the provider changes
* Improve `php_source` provider for `php_version` so that a version of PHP is tested to confirm it is working. Failing this check will then trigger a recompile. As an example this will fix the zlib library version changing.

## 0.5.5 ##

* Add additional PHP versions, thanks @webflo
* Add new `php_source` extension provider which can install php extensions bundled with the PHP source code

## 0.5.4 ##

* Fix config issue with xdebug extension

## 0.5.3 ##

* Add xdebug extension

## 0.5.2 ##

* Fix zlib linking issue [#22](https://github.com/mattheath/puppet-php/pull/22), thanks @curtishenson!

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
