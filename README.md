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

```puppet
# install a version and use as the global default
php::version { '5.3.20':
  global => true
}
```

```puppet
# install a local version to be used within a directory
php::local { '/path/to/my/awesome/project', '5.4.9': }
```