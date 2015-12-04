class LlvmOriginal < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/CbC/LLVM_original", using: :hg
  version "llvm3.8"

  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    mktemp do
      system "#{buildpath}/configure", "--prefix=#{prefix}",
                            "--disable-optimized", "--enable-assertions",
                            "--enable-debug-runtime", "--enable-debug-symbols"
      system "make -j 2"
      system "make", "install"
    end
  end
end
