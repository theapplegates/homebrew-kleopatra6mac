class QgpgmeQt6 < Formula
  desc "Qt6 bindings for GPGME"
  homepage "https://invent.kde.org/pim/qgpgme-qt6"

  url "https://invent.kde.org/pim/qgpgme-qt6/-/archive/v1.23.2/qgpgme-qt6-v1.23.2.tar.bz2"
  sha256 "75e0928abfe1e6b8cdb4e0a84aaabc37735405ead1d4cd4f70fe33b250648df5"
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
