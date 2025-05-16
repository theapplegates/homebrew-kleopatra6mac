class Kf6Kconfig < Formula
  desc "Configuration system for Qt-based applications"
  homepage "https://invent.kde.org/frameworks/kconfig"
  url "https://download.kde.org/stable/frameworks/6.14/kconfig-6.14.0.tar.xz"
  sha256 "60d6ae1db0f09a9c1ac94b573b801505928b832d7d0b24c627b6e92c98e21b0c"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"
  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"

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
      #include <KConfig>
      int main() {
        KConfig config("testrc");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lKF6ConfigCore"
    system "./test"
  end
end
