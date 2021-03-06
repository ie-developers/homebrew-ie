# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb

class Cbclang < Formula
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
      if MacOS.version >= 10.15
      llvm  =  Utils.popen_read("/usr/local/bin/brew","--prefix","llvm").chomp
         ENV['CC'] = llvm + "/bin/clang"
         ENV['CXX'] = llvm + "/bin/clang++"
         ENV['LLVM_DIR'] = buildpath
         ENV['PATH'] = ENV['PATH'] + ":/usr/local/bin"
      end 
      system "cmake","-G","Ninja","-DCMAKE_BUILD_TYPE:STRING=Debug","-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}","-DLLVM_ENABLE_PROJECTS=clang;lld","#{buildpath}/llvm"
      system "ninja"
      system "ninja", "install"
    end
  end

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 3
    cellar :any
    sha256 "ce87e33bcb2a285d366f2854fb28349a5df3426f4eb8701a23c4c4749316f74f" => :mojave
    sha256 "ce87e33bcb2a285d366f2854fb28349a5df3426f4eb8701a23c4c4749316f74f" => :catalina
  end

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 4
    cellar :any
    sha256 "3839aab15f6d12495199fe380022b4374785a5d62262efbdeda3c4311164d696" => :mojave
    sha256 "3839aab15f6d12495199fe380022b4374785a5d62262efbdeda3c4311164d696" => :catalina
  end

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    rebuild 1
    cellar :any
    sha256 "6f3d05bc49bd9c92177dfa8253a56180a27c6ec28279760cad1b380b795b363a" => :mojave
  end

  bottle do
    root_url "http://www.cr.ie.u-ryukyu.ac.jp/brew" # Optional root to calculate bottle URLs
    cellar :any
    rebuild 2
    sha256 "3aae7391ff6099099aa20b357e03ddafa179fef18f35f03fedd49ecf87fb6124" => :catalina
  end

  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end

end
