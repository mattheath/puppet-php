# A Boxen-focused PHP project setup helper
#
# Options:
#
#     dir =>
#       The directory to clone the project to.
#       Defaults to "${boxen::config::srcdir}/${name}".
#
#     dotenv =>
#       If true, creates "${dir}/.env" from
#       "puppet:///modules/projects/${name}/dotenv".
#
#     elasticsearch =>
#       If true, ensures elasticsearch is installed.
#
#     memcached =>
#       If true, ensures memcached is installed.
#
#     mongodb =>
#       If true, ensures mongodb is installed.
#
#     cassandra =>
#       If true, ensures cassandra is installed.
#
#     zookeeper =>
#       If true, ensures zookeeper is installed.
#
#     beanstalk =>
#       If true, ensures beanstalk is installed.
#
#     nsq =>
#       If true, ensures nsq is installed.
#
#     zeromq =>
#       If true, ensures zeromq is installed.
#
#     mysql =>
#       If set to true, ensures mysql is installed and creates databases named
#       "${name}_development" and "${name}_test".
#       If set to any string or array value, creates those databases instead.
#
#     nginx =>
#       If true, ensures nginx is installed and uses standard template at
#       modules/projects/templates/shared/nginx.conf.erb.
#       If given a string, uses that template instead.
#
#     postgresql =>
#       If set to true, ensures postgresql is installed and creates databases
#       named "${name}_development" and "${name}_test".
#       If set to any string or array value, creates those databases instead.
#
#     redis =>
#       If true, ensures redis is installed.
#
#     ruby =>
#       If given a string, ensures that ruby version is installed.
#       Also creates "${dir}/.ruby-version" with content being this value.
#
#     php =>
#       If given a string, ensures that php version is installed.
#       Also creates "${dir}/.php-version" with content being this value.
#
#     source =>
#       Repo to clone project from. REQUIRED. Supports shorthand <user>/<repo>.
#
#     server_name =>
#       The hostname to use when accessing the application.
#
#     fpm_pool_config =>
#       Location of custom FPM pool configuration file template.
#

define php::project(
  $source,
  $dir           = undef,
  $dotenv        = undef,
  $elasticsearch = undef,
  $memcached     = undef,
  $mongodb       = undef,
  $cassandra     = undef,
  $zookeeper     = undef,
  $beanstalk     = undef,
  $nsq           = undef,
  $zeromq        = undef,
  $mysql         = undef,
  $nginx         = undef,
  $nodejs        = undef,
  $postgresql    = undef,
  $redis         = undef,
  $ruby          = undef,
  $php           = undef,
  $server_name   = "${name}.dev",
  $fpm_pool_config   = undef,
) {
  include boxen::config

  $repo_dir = $dir ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $dir
  }

  repository { $repo_dir:
    source => $source
  }

  if $dotenv {
    file { "${repo_dir}/.env":
      source  => "puppet:///modules/projects/${name}/dotenv",
      require => Repository[$repo_dir],
    }
  }

  if $elasticsearch {
    include elasticsearch
  }

  if $memcached {
    include memcached
  }

  if $mongodb {
    include mongodb
  }

  if $cassandra {
    include cassandra
  }

  if $beanstalk {
    include beanstalk
  }

  if $zookeeper {
    include zookeeper
  }

  if $zeromq {
    include zeromq
  }

  if $nsq {
    include nsq
  }

  if $mysql {
    $mysql_dbs = $mysql ? {
      true    => ["${name}_development", "${name}_test"],
      default => $mysql,
    }

    mysql::db { $mysql_dbs: }
  }

  if $nginx {
    include nginx::config
    include nginx

    $nginx_templ = $nginx ? {
      true    => 'projects/shared/nginx.conf.erb',
      default => $nginx,
    }

    file { "${nginx::config::sitesdir}/${name}.conf":
      content => template($nginx_templ),
      require => File[$nginx::config::sitesdir],
      notify  => Service['dev.nginx'],
    }
  }

  if $nodejs {
    nodejs::local { $repo_dir:
      version => $nodejs,
      require => Repository[$repo_dir],
    }
  }

  if $postgresql {
    $psql_dbs = $postgresql ? {
      true    => ["${name}_development", "${name}_test"],
      default => $postgresql,
    }

    postgresql::db { $psql_dbs: }
  }

  if $redis {
    include redis
  }

  if $ruby {
    ruby::local { $repo_dir:
      version => $ruby,
      require => Repository[$repo_dir]
    }
  }

  if $php {
    # Set the local version of PHP
    php::local { $repo_dir:
      version => $php,
      require => Repository[$repo_dir],
    }

    # Spin up a PHP-FPM pool for this project, listening on an Nginx socket
    php::fpm::pool { "${name}-${php}":
      version => $php,
      socket  => "${boxen::config::socketdir}/${name}",
      require => File["${nginx::config::sitesdir}/${name}.conf"],
    }

    if $fpm_pool_config {
      Php::Fpm::Pool["${name}-${php}"] {
        fpm_pool_config => $fpm_pool_config
      }
    }
  }

}
