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
  # sha256 "582dfb8e99be98641f2fec3b9b08a4587e676e8306c0be00db478080320ff800"
  license ""

  # depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt@5" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # require 'shell'
    # sh = Shell.new
    # p sh.cwd
    # system "ls","-l"
    # system "autoreconf", "--install"
    ENV["GYP_DEFINES"] = "mac_sdk= mac_deployment_target=11.3"
    cd "src" do
      # system "python3", "build_mozc.py", "gyp", "--noqt"
      # system "python3", "build_mozc.py","build","-c","Release","mac/mac.gyp:GoogleJapaneseInput"
      system "python3", "build_mozc.py", "gyp", "--qtdir", Formula["qt@5"].opt_prefix.to_s
      system "python3", "build_mozc.py", "build", "-c", "Release", "gui/gui.gyp:config_dialog_main"
      system "python3", "build_mozc.py", "build", "-c", "Release", ":Installer"
      # install package is created execute by the user
      system "cp","out_mac/Release/Mozc.pkg",#{prefix}
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
