require 'formula'

class Zlibphp < Formula
  homepage 'http://www.zlib.net/'
  url 'http://zlib.net/zlib-1.2.8.tar.gz'
  sha1 'a4d316c404ff54ca545ea71a27af7dbc29817088'

  keg_only :provided_by_osx

  version '1.2.8-boxen1'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

