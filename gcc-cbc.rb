# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class CbcGcc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg, revision: "21681fa9647e"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg
  version "llvm3.8"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"

  keg_only "Conflict with original clang"

  def install
    mktemp do
      system "#{buildpath}/configure", "--prefix=#{prefix}", "--disable-nls" ,  "--disable-bootstrap","--enable-checking=tree,rtl,assert,types","CFLAGS=\"-g3 -O0\"", "--enable-languages=c,lto", "--no-create", "--no-recursion", "--disable-multilib"
      system "make -j 4"
      system "make", "install"
    end
  end
end
