# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbcgcc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg, revision: "current"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  version "10.0.1"
  bottle do 
    sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a" => :mojave
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :catalina
  end

  keg_only "Conflict with various gcc"
  depends_on"gmp"
  depends_on "mpfr"
  depends_on "libmpc"

  def install
    mktemp do
      system "#{buildpath}/configure", "--prefix=#{prefix}", "--disable-nls" ,  "--disable-bootstrap","--enable-checking=tree,rtl,assert,types","CFLAGS=-g3 -O0", "--enable-languages=c,lto", "--no-create", "--no-recursion", "--disable-multilib"
      system "sh config.status"
      system "make -j 4"
      system "make", "install"
    end
  end
  #   cbcgcc-10.0.1.
  bottle do
    rebuild 1
    root_url "https://cr.ie.u-ryukyu.ac.jp/brew/" # Optional root to calculate bottle URLs
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :mojave
  end


  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end
end
