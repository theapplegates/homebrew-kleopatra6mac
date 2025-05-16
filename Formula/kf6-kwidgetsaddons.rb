class Kf6Kwidgetsaddons < Formula
  desc "Addons to QtWidgets – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kwidgetsaddons"
  url "https://download.kde.org/stable/frameworks/6.14/kwidgetsaddons-6.14.0.tar.xz"
  sha256 "847a47de68996a22e69f1bcd12f37ed29f97e6c25a43de27aa49ae2d9de77c30"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"
  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"

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
      #include <KAcceleratorManager>
      int main() {
        QString text = KAcceleratorManager::accelerated("Hello &World");
        return text.isEmpty() ? 1 : 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6WidgetsAddons"
    system "./test"
  end
end
