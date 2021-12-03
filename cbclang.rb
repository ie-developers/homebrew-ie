# typed: false
# frozen_string_literal: true

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbclang < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", tag: "before-12", using: :hg # , revision: "llvm10"
  version "llvm10"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 1
    sha256 "cea094bdedca36239812bdb8655806caa34194e0ccb181e06e0b945742d97569" => :catalina
    sha256 "2ba57ee76a34d34db3424a2385a9ce3c49db1a17abada8fe533d8f618ea4b26d" => :big_sur
    sha256 "849051152676d540389fbe4029f430dc194bce4035936f6724761b2d7a0c1a70" => :mojave
    sha256 "934140268cd63de051b90f371a88ca6a9d4d44c32767b8278950abb3e5ea55d4" => :arm64_big_sur
  end

  keg_only "conflict with original clang"

  depends_on "mercurial"
  depends_on "cmake"
  depends_on "ninja"
  depends_on "llvm"

  def install
    mktemp do
      $stderr.puts "before compile\n sudo launchctl stop com.apple.MRTd \n otherwise MRT may run crazy\nthis build may take 18GB\n"
      if MacOS.version >= 10.15
        # llvm = Utils.safe_popen_read("brew", "--prefix", "llvm").chomp
        llvm = Formula["llvm"].prefix
        ENV["CC"] = "#{llvm}/bin/clang"
        ENV["CXX"] = "#{llvm}/bin/clang++"
        ENV["LLVM_DIR"] = buildpath
        ENV["PATH"] = "#{ENV["PATH"]}:/usr/local/bin"
      end
      # if MacOS.version >= 11.0
      #   ENV["SDKROOT"]=Utils.safe_popen_read( "/usr/bin/xcrun","--sdk","macosx","--show-sdk-path").chomp
      # end
      # system "cmake", "-G", "Ninja", "-DCMAKE_BUILD_TYPE:STRING=Debug", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
      #        "-DLLVM_ENABLE_PROJECTS=clang;lld", "#{buildpath}/llvm"
      system "cmake", "-G", "Ninja", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
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
