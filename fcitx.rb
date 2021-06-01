# typed: false
# frozen_string_literal: true

# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Fcitx < Formula
  desc ""
  homepage ""
  url "https://github.com/fcitx/fcitx.git"
  version "2.3"
  license ""

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "iso-codes"
  depends_on "json-c"
  depends_on "libxkbcommon"
  depends_on "libxkbfile"

  def install
    patch = <<~HEREDOC
            *** src/lib/fcitx-utils/utils.c 2021-05-02 00:49:04.000000000 +0900
            --- src/lib/fcitx-utils/utils.c.orig    2021-05-02 00:45:47.000000000 +0900
            ***************
            *** 65,74 ****
      #{"      "}
              #if defined(__linux__) || defined(__GLIBC__)
              #include <endian.h>
            - #else
            - #if defined(__APPLE__)
            - #include <sys/_endian.h>
              #else
              #include <sys/endian.h>
              #endif
            - #endif
      #{"      "}
            --- 65,70 ----
    HEREDOC
    File.open("fix.patch", "w") { |file| file.write(patch); file.close }
    # patch does not work
    system "sed", "-i", "orig", "-e", "s-sys/endian.h-machine/endian.h-", "src/lib/fcitx-utils/utils.c"
    mktemp do
      system "cmake", "-G", "Ninja", "-DENABLE_OPENCC=OFF", "-DFORCE_OPENCC=OFF", "-DENABLE_GIR=OFF",
             "-DENABLE_CAIRO=OFF", "-DENABLE_QT=OFF", "-DENABLE_QT_IM_MODULE=OFF", "-DENABLE_GTK2_IM_MODULE=OFF", "-DENABLE_GTK3_IM_MODULE=OFF", "-DENABLE_SNOOPER=OFF", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", buildpath.to_s
      system "ninja", "-k"
      system "ninja", "install"
    end
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
