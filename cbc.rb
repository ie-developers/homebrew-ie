# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url  "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg # , revision: "llvm10"
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/CbC_llvm", using: :hg
  version "llvm10"
  sha256 "b55dd4426265c52c517f79b2c79d0e556168c14c6ed5e79b51b6cf2f52f43e2a"
  depends_on"cmake"
  depends_on"ninja"

  keg_only "Conflict with original clang"

  def install
    mktemp do
      STDERR.puts"before compile\n sudo launchctl stop com.apple.MRTd \n otherwise MRT may run crazy\nthis build may take 18GB\n"
      llvm  =  Utils.popen_read("/usr/local/bin/brew","--prefix","llvm").chomp
      ENV['CC'] = llvm + "/bin/clang"
      ENV['CXX'] = llvm + "/bin/clang++"
      ENV['LLVM_DIR'] = buildpath
      ENV['PATH'] = ENV['PATH'] + ":/usr/local/bin"
      system "cmake","-G","Ninja","-DCMAKE_BUILD_TYPE:STRING=Debug","-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}","-DLLVM_ENABLE_PROJECTS=clang;lld","#{buildpath}/llvm"
      system "ninja"
      system "ninja", "install"
    end
  end

  bottle do
    rebuild 1
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :mojave
    sha256 "cd7ea217a174e440cfd7bf6e1367ceca7daae8f6ca9805056dd117e6cbc3ce97" => :catalina
  end

end
