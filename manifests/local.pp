# Set a directory's default php version for phpenv.
# Automatically ensures that php version is installed
#
# Usage:
#
#     php::local { '/path/to/a/thing': version => '5.4.10' }
#
define php::local($version = undef, $ensure = present) {
  include php::config

  if $version != 'system' and $ensure == present {
    # Requires php version eg. php::5-4-10
    require join(['php', join(split($version, '[.]'), '-')], '::')
  }

  file { "${name}/.php-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true
  }
}
