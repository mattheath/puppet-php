# Set a directory's default php version via phpenv.
# Automatically ensures that php version is installed via phpenv & php-build
#
# Usage:
#
#     php::local { '/path/to/a/thing': version => '5.4.10' }
#
define php::local($version = undef, $ensure = present) {
  if $version != 'system' and $ensure == present {
    php::version{ $version: }
  }

  file {
    "${name}/.php-version":
      ensure  => $ensure,
      content => "${version}\n",
      replace => true ;
  }
}
