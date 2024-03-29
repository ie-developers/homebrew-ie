# typed: false
# frozen_string_literal: true

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class CbcgccArm < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg, revision: "current"
  version "10.0.1"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_gcc", using: :hg

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "4194fc03868dd0e88a79a04f82d7cc92ae5f115533b67104b80935146e6094f2" 
    sha256 cellar: :any_skip_relocation, catalina: "2fd3e98cf6479b7dd29258345b29a0d288b9b37704bacf5af3049450b54f1a56" 
  end

  keg_only "conflict with various gcc"
  depends_on "cesarvandevelde/formulae/arm-none-eabi-gcc"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"
  # use build from source as `brew install -s cesarvandevelde/formulae/arm-none-eabi-gcc` in Catalina # "ARMmbed/formulae/arm-none-eabi-gcc"

  def install
    mktemp do
      File.open("make.sh", "w") { |f| f.write "\#!/bin/sh\nmake \"$@\"\nexit 0\n" }
      arm = Utils.safe_popen_read("/usr/local/bin/brew", "--prefix",
                                  "cesarvandevelde/formulae/arm-none-eabi-gcc").chomp
      # path =  Utils.popen_read("/usr/bin/find","#{arm}/","-name","stddef.h","-print`")
      # inc  =  path[0..-10]
      ENV["TARGET"] = "arm-none-eabi"
      ENV["PREFIX"] = "#{arm}/gcc"
      ENV["PATH"] = "#{ENV["PATH"]}:#{arm}/gcc/bin"
      system "#{buildpath}/configure",
             "--target=arm-none-eabi",
             "--prefix=#{prefix}",
             "--with-as=#{arm}/bin/arm-none-eabi-as", "--with-ld=#{arm}/bin/arm-none-eabi-ld",
             "--disable-nls",
             "--disable-bootstrap",
             "--enable-checking=tree,rtl,assert,types",
             "--no-create", "--no-recursion",
             "--with-arch=armv7-a", "--with-fpu=vfp", "--with-float=hard",
             "CFLAGS=-g3 -O0",
             "--enable-languages=c,lto",
             "--disable-multilib",
             "--disable-werror",
             "--disable-libssp", "--disable-libstdcxx-pch", "--disable-libmudflap",
             "--with-newlib",
             "--enable-interwork",
             "--with-headers=yes"
      # "--with-headers=#{arm}/gcc/arm-none-eabi/include,#{inc}"
      system "sh", "config.status"
      system "sh", "make.sh", "-k", "-j", "20" # for firefly
      system "sh", "make.sh", "-k", "install"
      # raise
    end
  end

  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end
end
