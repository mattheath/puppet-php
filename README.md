# PHP Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`
* `homebrew`
* `wget`

## Usage

```puppet
# install a php version or two
php::version { '5.3.20': }
php::version { '5.4.10': }
```