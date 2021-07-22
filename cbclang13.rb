# typed: false
# frozen_string_literal: true

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbclang13 < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  # url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", tag: "before-12", using: :hg # , revision: "llvm10"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg # , revision: "llvm10"
  version "1"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 3
    sha256 arm64_big_sur: "1e7ab91d73efe72eed8681fb21046f90b3323bbe29f78eceb751bca587c86303"
    sha256 catalina: "8a9bc3205653f8bdd5a977f70ecd034683f12f253b1b8e7a8b316050b72eec9f"
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
