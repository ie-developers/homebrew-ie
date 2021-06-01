# typed: false
# frozen_string_literal: true

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbclang < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg # , revision: "llvm10"
  version "llvm10"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    cellar :any
    sha256 cellar: :any, mojave: "3839aab15f6d12495199fe380022b4374785a5d62262efbdeda3c4311164d696" 
    sha256 cellar: :any, catalina:"3839aab15f6d12495199fe380022b4374785a5d62262efbdeda3c4311164d696" 
  end

  keg_only "conflict with original clang"

  depends_on "cmake"
  depends_on "ninja"

  def install
    mktemp do
      $stderr.puts "before compile\n sudo launchctl stop com.apple.MRTd \n otherwise MRT may run crazy\nthis build may take 18GB\n"
      if MacOS.version >= 10.15
        llvm = Utils.safe_popen_read("/usr/local/bin/brew", "--prefix", "llvm").chomp
        ENV["CC"] = "#{llvm}/bin/clang"
        ENV["CXX"] = "#{llvm}/bin/clang++"
        ENV["LLVM_DIR"] = buildpath
        ENV["PATH"] = "#{ENV["PATH"]}:/usr/local/bin"
      end
      system "cmake", "-G", "Ninja", "-DCMAKE_BUILD_TYPE:STRING=Debug", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
             "-DLLVM_ENABLE_PROJECTS=clang;lld", "#{buildpath}/llvm"
      system "ninja"
      system "ninja", "install"
    end
  end

  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end
end
