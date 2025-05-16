class Kf6Kconfigwidgets < Formula
  desc "Widgets for KConfig – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kconfigwidgets"
  url "https://download.kde.org/stable/frameworks/6.14/kconfigwidgets-6.14.0.tar.xz"
  sha256 "41cce41a3a8e1f76a04cb0dd546b87b4cc4fd3f573ed55b4f627bfc3c0eae63a"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
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
      #include <KStandardAction>
      int main() {
        QAction *a = KStandardAction::quit(nullptr);
        return a ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{Formula["qt@6"].opt_include}", "-I#{include}", "-L#{lib}", "-lKF6ConfigWidgets"
    system "./test"
  end
end
