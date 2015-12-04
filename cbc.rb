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


  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    mktemp do
      system "#{buildpath}/configure", "--prefix=#{prefix}",
                            "--disable-optimized",
                            "--enable-assertions"
      # system "cmake", ".", *std_cmake_args
      system "make -j 2" # if this fails, try separate make/make install steps
      system "make", "install"
    end
    bin.install_symlink "#{libexec}/bin/clang" => "cbc-clang"
  end
end
