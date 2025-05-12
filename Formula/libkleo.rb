class Libkleo < Formula
  desc "GPG key management library (used by Kleopatra)"
  homepage "https://invent.kde.org/pim/libkleo"
  url "https://invent.kde.org/pim/libkleo/-/archive/v22.07.80/libkleo-v22.07.80.tar.bz2"
  sha256 "PUT_THE_CORRECT_SHA256_HERE"
  license "LGPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "qt@6"
  depends_on "theapplegates/qgpgme-qt6/qgpgme-qt6"
  depends_on "kde-mac/kde/kf6-core-addons"
  depends_on "kde-mac/kde/kf6-kio"
  depends_on "kde-mac/kde/kf6-xmlgui"
  # ...add any other KF6 deps you need...

  def install
    mkdir "build" do
      system "cmake", "..",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DBUILD_TESTING=OFF",
             *std_cmake_args
      system "make", "-j#{ENV.make_jobs}", "install"
    end
  end

  test do
    assert_predicate lib/"libKF6kleo.dylib", :exist?
  end
end
