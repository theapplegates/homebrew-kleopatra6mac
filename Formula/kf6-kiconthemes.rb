class Kf6Kiconthemes < Formula
  desc "Support for icon themes – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kiconthemes"
  url "https://download.kde.org/stable/frameworks/6.14/kiconthemes-6.14.0.tar.xz"
  sha256 "2f07f4e3fbe9f379b2f3d6904a5a75a84a88d5cd51cb0a7fdd31fc21acba722e"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
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
      #include <KIconTheme>
      int main() {
        KIconTheme *theme = KIconTheme::current();
        return theme ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6IconThemes"
    system "./test"
  end
end
