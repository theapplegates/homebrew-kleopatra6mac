class Kf6Kcmutils < Formula
  desc "Utilities for handling KConfig modules – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kcmutils"
  url "https://download.kde.org/stable/frameworks/6.14/kcmutils-6.14.0.tar.xz"
  sha256 "4384c7d587f4e032fbb22378df6e70e21295c36e154abcc23f112b7244fdf4db"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kxmlgui"
  depends_on "theapplegates/kleopatra6mac/kf6-kservice"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"

  def install
    args = std_cmake_args + %W[
      -DBUILD_QCH=OFF
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <KCMUtils/KCModule>
      int main() {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6KCMUtils"
    system "./test"
  end
end
