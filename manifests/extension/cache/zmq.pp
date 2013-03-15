# Provides a cached copy of the zmq extension source code
#
# This has been refactored into a separate class so that it can be
# instantiated multiple times - for example if multiple versions of
# php are installed with the zmq extension

class php::extension::cache::zmq {

  require php::config
  require php

  # Clone the source repository
  repository { "${php::config::extensioncachedir}/zmq":
    source  => 'mkoppanen/php-zmq',
    require => File["${php::config::extensioncachedir}"],
  }

}
