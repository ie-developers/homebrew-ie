# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cbc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg, revision: "99580de8d21d"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg
  version "llvm3.7"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"

  bottle do
    root_url 'http://urasoe.ie.u-ryukyu.ac.jp/brew'
    sha256 "acfc07ddfc85daf52e9717f82d026b20bc1196cd5cfeefc0e4b92a493bc10b78" => :yosemite
  end


  def install
    mktemp do
      system "#{buildpath}/configure", "--prefix=#{prefix}", "--enable-assertions"
      system "make -j 2"
      system "make", "install"
    end
    bin.install_symlink "#{prefix}/bin/clang" => "cbc-clang"
  end
end
