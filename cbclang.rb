# typed: false
# frozen_string_literal: true

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbclang < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", tag: "current", using: :hg # , revision: "llvm10"
  version "llvm18"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 1
    sha256 cellar: :any, arm64_ventura: "0d792f6ae8f7cf39546d8d74a8ed6b78313a80e48b3e3b94af19c70677b3880f"
    sha256 cellar: :any_skip_relocation, catalina: "cea094bdedca36239812bdb8655806caa34194e0ccb181e06e0b945742d97569" 
    sha256 cellar: :any_skip_relocation, big_sur: "2ba57ee76a34d34db3424a2385a9ce3c49db1a17abada8fe533d8f618ea4b26d" 
    sha256 cellar: :any_skip_relocation, mojave: "849051152676d540389fbe4029f430dc194bce4035936f6724761b2d7a0c1a70" 
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "934140268cd63de051b90f371a88ca6a9d4d44c32767b8278950abb3e5ea55d4" 
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c962b229614a2b9975d228913b75c7310cb0206438c8273a0baa39a0e6885d7"
    sha256 cellar: :any_skip_relocation, ventura: "1d3160662cf70b494a8a9a5386031a6172e98510986929a8287db465bfde8a4d"
  end

  keg_only "conflict with original clang"

  depends_on "mercurial"
  depends_on "cmake"
  depends_on "ninja"
  depends_on "llvm"

  def install
    mktemp do
      $stderr.puts "before compile\n sudo launchctl stop com.apple.MRTd \n otherwise MRT may run crazy\nthis build may take 18GB\n"
      #  CPU.intel is a workaround for bad llvm in intel mac
      if MacOS.version >= :catalina && !Hardware::CPU.intel?
        # llvm = Utils.safe_popen_read("brew", "--prefix", "llvm").chomp
        llvm = Formula["llvm"].prefix
        ENV["CC"] = "#{llvm}/bin/clang"
        ENV["CXX"] = "#{llvm}/bin/clang++"
        ENV["LLVM_DIR"] = buildpath
        ENV["PATH"] = "#{ENV["PATH"]}:/usr/local/bin"
      end
      macos_sdk = MacOS.sdk_path
      print [ "cmake", "-G", "Ninja", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
             "-DLLVM_INCLUDE_TESTS=OFF", "-DLLVM_INCLUDE_EXAMPLES=OFF", "-DLLVM_INCLUDE_DOCS=OFF",
             "-DCMAKE_INSTALL_LIBDIR=lib",  "-DCMAKE_FIND_FRAMEWORK=LAST",
             "-DCMAKE_VERBOSE_MAKEFILE=ON","-Wno-dev","-DCMAKE_OSX_SYSROOT=${macos_sdk}",
             "-DLLVM_ENABLE_PROJECTS=clang;lld", "#{buildpath}/llvm/" ].join(" ")
      puts ""
      system "cmake", "-G", "Ninja", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}",
             "-DLLVM_INCLUDE_TESTS=OFF", "-DLLVM_INCLUDE_EXAMPLES=OFF", "-DLLVM_INCLUDE_DOCS=OFF",
             "-DCMAKE_INSTALL_LIBDIR=lib",  "-DCMAKE_FIND_FRAMEWORK=LAST",
             "-DCMAKE_VERBOSE_MAKEFILE=ON","-Wno-dev","-DCMAKE_OSX_SYSROOT=${macos_sdk}",
             "-DLLVM_ENABLE_PROJECTS=clang;lld", "#{buildpath}/llvm/"
      ## puts "pwd = ",Dir.pwd,ENV["CXX"]  ( build dire is wrong after debug shell. do cmake again to debug )
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
