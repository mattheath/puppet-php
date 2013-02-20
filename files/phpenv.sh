# Configure and activate phpenv. You know, for php.

export PHPENV_ROOT=$BOXEN_HOME/phpenv

export PATH=$BOXEN_HOME/phpenv/bin:$BOXEN_HOME/phpenv/plugins/php-build/bin:$PATH

eval "$(phpenv init -)"
