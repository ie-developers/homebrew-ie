# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbcgcc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  version "10.0.1"

  bottle do 
    rebuild 1
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :mojave
    sha256 "9465b16d6e5443290600bf9bb11c8d2c46f1d3992bcd5d56f85bd2c698e2e6eb" => :catalina
  end

  keg_only "Conflict with various gcc"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "zstd"

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d+/)
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    mktemp do
      args = "--prefix=#{prefix} --disable-nls --disable-bootstrap --enable-checking=tree,rtl,assert,types "
        + "CFLAGS=\"-g3 -O0\" --enable-languages=c,lto --no-create --no-recursion --disable-multilib "

      args << "--disable-multilib " if DevelopmentTools.clang_build_version >= 1000
      args << "SED=/usr/bin/sed " 
      args << "--with-system-zlib "

      if MacOS.version >= 10.15 
        args << "--disable-libstdcxx "
        system "cd #{buildpath};#{buildpath}/contrib/download_prerequisites"
        sdk_path = `xcrun --sdk macosx --show-sdk-path`
        #sdk_path = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
        args << "--with-sysroot=#{sdk_path} "
      end
      system "#{buildpath}/configure #{args}"
      system "./config.status"
      system "make -j 4"
      system "make", "install"
    end
  end
  #   cbcgcc-10.0.1.

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
