# typed: false
# frozen_string_literal: true

# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class FcitxMozc < Formula
  desc ""
  homepage ""
  url "https://github.com/fcitx/mozc.git"
  version "2.3"
  license ""
  bottle do
    root_url "https://ie.u-ryukyu.ac.jp/brew/fcitx-mozc"
    sha256 "ffe95bd0af017b7ba5acf5d39ec9cde8d2e66059dfc8b8a7d95bb449de7a5364" => :big_sur
  end

  # depends_on "cmake" => :build
  depends_on "ninja" => :build
  # depends_on "qt@5" => :build

  def install
    # we need Packages to build this
    # http://s.sudre.free.fr/Software/Packages/about.html
    #
    ENV["GYP_DEFINES"] = "mac_sdk= mac_deployment_target=11.3"
    cd "src" do
      system "python3", "build_mozc.py", "gyp", "--noqt"
      system "python3", "build_mozc.py", "build", "-c", "Release", "mac/mac.gyp:GoogleJapaneseInput"
      # system "python3", "build_mozc.py", "gyp", "--qtdir", Formula["qt@5"].opt_prefix.to_s
      # system "python3", "build_mozc.py", "build", "-c", "Release", "gui/gui.gyp:config_dialog_main"
      # system "echo python3 build_mozc.py build -c Release gui/gui.gyp:config_dialog_main \\; exit 0 > do.sh";
      # system "sh do.sh"
      system "python3", "build_mozc.py", "build", "-c", "Release", ":Installer"
      # install package is created execute by the user
      # system "cp","out_mac/Release/Mozc.pkg","#{prefix}"
      prefix.install "out_mac/Release/Mozc.pkg"
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
