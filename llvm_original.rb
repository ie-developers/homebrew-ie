class LlvmOriginal < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/LLVM_original", using: :hg
  version "llvm3.8"

  bottle do
    cellar :any
    root_url 'http://www.ie.u-ryukyu.ac.jp/brew'
    sha256 "20af48c4ef50e776b0b894d15d6d517808214c5126be463019519b5f457bdcfe" => :yosemite
  end

  def install
    mkdir("#{prefix}/build") do
      system "#{buildpath}/configure", "--prefix=#{prefix}",
                            "--enable-debug-runtime", "--enable-debug-symbols",
                            "--disable-optimized", "--enable-assertions"
      system "make -j 2"
      system "make", "install"
    end
  end
end
