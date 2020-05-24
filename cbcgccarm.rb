# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbcgccarm < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg, revision: "current"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  version "10.0.1"


  keg_only "Conflict with various gcc"
  depends_on"gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "arm-none-eabi-gcc"

  def install
    mktemp do
      arm = `/usr/local/bin/brew --prefix arm-none-eabi-gcc`.chomp
      path = `/usr/bin/find #{arm}/ -name stddef.h -print`
      inc =  path[0..-10]
      system "#{buildpath}/configure",
         "--target=arm-elf-eabi",
         "--prefix=#{prefix}",
         "--disable-nls" ,
         "--disable-bootstrap",
         "--enable-checking=tree,rtl,assert,types",
         "CFLAGS=-g3 -O0",
         "--enable-languages=c,lto",
         "--disable-multilib" ,
         "--disable-werror",
         "--disable-libssp", "--disable-libstdcxx-pch", "--disable-libmudflap",
         "--with-newlib",
         "--with-headers=#{arm}/gcc/arm-none-eabi/include,#{inc}"
      system "sh config.status"
      system "make -j 4"
      system "make", "install"
    end
  end
  bottle do
    rebuild 1
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :mojave
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :catalina
  end


  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end
end
