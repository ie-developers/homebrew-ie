# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbcgcc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg, revision: "tip"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  version "10.0.1"

  bottle do 
    rebuild 1
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :mojave
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :catalina
  end

  keg_only "Conflict with various gcc"

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d+/)
    end
  end


  def install
    mktemp do

    args = %W[
      --prefix=#{prefix}
      --disable-nls
      --disable-bootstrap
      --enable-checking=tree,rtl,assert,types
      CFLAGS="-g3 -O0"
      --enable-languages=c,lto
      --no-create
      --no-recursion
      --disable-multilib
    ]


    if MacOS.version >= 10.15 
      system "cd #{buildpath};#{buildpath}/contrib/download_prerequisites"
      args << "--with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
    end

      system "#{buildpath}/configure", *args
      system "sh config.status"
      system "make -j 4"
      system "make", "install"
    end
  end
  #   cbcgcc-10.0.1.


  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end
end
