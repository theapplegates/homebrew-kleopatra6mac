class QgpgmeQt6 < Formula
  desc "Qt6 bindings for GPGME"
  homepage "https://invent.kde.org/pim/qgpgme-qt6"
  url "https://invent.kde.org/pim/qgpgme-qt6/-/archive/v1.23.2/qgpgme-qt6-v1.23.2.tar.bz2"
  sha256 "2f1f7328857a9bc57c34d42fb02c4def53b3cd62c973f6177e37e6c638756bab"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "qt@6"
  depends_on "gpgme"

  def install
    mkdir "build" do
      system "cmake", "..",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DBUILD_QT6_BINDING=ON", "-DBUILD_QT5_BINDING=OFF",
             "-DBUILD_TESTING=OFF",
             *std_cmake_args
      system "make", "-j#{ENV.make_jobs}", "install"
    end
  end

  test do
    assert_predicate include/"qgpgme_export.h", :exist?
  end
end
