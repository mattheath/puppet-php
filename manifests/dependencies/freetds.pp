# Installs freetds 9.1
#
# Usage:
#
#     include php::dependencies::freedtds
#
class php::dependencies::freetds {

  homebrew::formula { 'freetds':
    source => 'puppet:///modules/php/brews/freetds.rb',
    before => Package['freetds'],
  }

  package { 'freetds':
    ensure => '0.91',
  }
}
