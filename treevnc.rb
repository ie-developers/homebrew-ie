# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/frames
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Treevnc < Formula
  homepage "http://www.cr.ie.u-ryukyu.ac.jp"
  url "http://www.cr.ie.u-ryukyu.ac.jp/hg/Applications/TreeVNC", using: :hg
  head "http://www.cr.ie.u-ryukyu.ac.jp/hg/Applications/TreeVNC", using: :hg
  version "1.0.0"
  sha256 "c8fce0c77636927f800fd12115fcca4ac7c598e6149e314ac2ab16df00328041"

  depends_on "gradle" => :build
  depends_on java: "1.8"
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    system "gradle", "installAPP"
    system "mv", "#{buildpath}/build/install/TreeVNC", "#{libexec}"
    bin.install_symlink "#{libexec}/bin/TreeVNC" => "treeVNC"
  end
end
