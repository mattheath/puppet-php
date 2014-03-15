require 'formula'

class Bisonphp26 < Formula
  homepage 'http://www.gnu.org/software/bison/'
  url 'http://ftpmirror.gnu.org/bison/bison-2.6.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bison/bison-2.6.5.tar.gz'
  sha1 '2cea0ea4a41dcfc05332613060026de0af1458cc'

  version '2.6.5-boxen1'

  keg_only :provided_by_osx, 'Some formulae require a newer version of bison.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end