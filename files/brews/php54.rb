require File.join(File.dirname(__FILE__), 'abstract-php')

class Php54 < AbstractPhp
  init
  url 'http://www.php.net/get/php-5.4.11.tar.bz2/from/this/mirror'
  sha1 '85666f32bf1f2850c769fe58fed788ae8fdfa1cb'
  version '5.4.11'

  head 'https://svn.php.net/repository/php/php-src/trunk', :using => :svn

  # Leopard requires Hombrew OpenSSL to build correctly
  depends_on 'openssl' if MacOS.version == :leopard

  def install_args
    args = super
    args << "--with-homebrew-openssl" if MacOS.version == :leopard
    args + [
      "--enable-zend-signals",
      "--enable-dtrace",
    ]
  end

  def php_version
    5.4
  end

  def php_version_path
    54
  end

end
