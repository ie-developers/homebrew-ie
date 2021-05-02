# typed: false
# frozen_string_literal: true

# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Uim < Formula
  desc ""
  homepage ""
  url "https://github.com/uim/uim.git"
  version "1.7"
  bottle do
    root_url "https://ie.u-ryukyu.sc.jp/brew/uim"
    sha256 big_sur: "b156bc11204b33358b582304860c857ef0d35ffa6f40a41a3f4bd9e9a1a77c86"
  end
  license ""

  # depends_on "cmake" => :build
  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build
  depends_on "anthy"
  depends_on "gettext"
  depends_on "intltool"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # require 'shell'
    # sh = Shell.new
    # p sh.cwd
    # system "ls","-l"
    # system "autoreconf", "--install"
    ENV["PKG_CONFIG_PATH"] = "/opt/X11/lib/pkgconfig"
    system "./make-wc.sh", *std_configure_args, "--disable-silent-rules"
    system "sed", "-i", "orig", "-e", "s/BROKEN_SNPRINTF/BROKEN_SNPRINTF1/", "replace/bsd-snprintf.c",
           "replace/os_dep.h"
    system "/usr/bin/make", "-j1"
    # system "false"
    system "(echo /usr/bin/make -j1 install ; echo exit 0 )> do.sh"
    system "sh", "do.sh"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test uim`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # system "false"
  end
end
