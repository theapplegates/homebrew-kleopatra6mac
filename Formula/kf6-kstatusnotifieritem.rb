class Kf6Kstatusnotifieritem < Formula
  desc "Implementation of Status Notifier Items – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kstatusnotifieritem"
  url "https://download.kde.org/stable/frameworks/6.14/kstatusnotifieritem-6.14.0.tar.xz"
  sha256 "b2c6a67e82dc15c253e10cf7f38cbfe7347652d2fa1d6a1a4741f4931f19bc38"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kiconthemes"

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
      #include <KStatusNotifierItem>
      int main() {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6StatusNotifierItem"
    system "./test"
  end
end
