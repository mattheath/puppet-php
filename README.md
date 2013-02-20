# PHP Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`
* `homebrew`

## Usage

```puppet
# install a php version
php::version { '5.3.20':
  global => true
}
```