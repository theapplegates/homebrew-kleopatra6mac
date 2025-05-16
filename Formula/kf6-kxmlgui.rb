class Kf6Kxmlgui < Formula
  desc "User configurable actions and UI definition – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kxmlgui"
  url "https://download.kde.org/stable/frameworks/6.14/kxmlgui-6.14.0.tar.xz"
  sha256 "89eaeefb98a40e3b14e8807282a9618fef6b57c2a3e949f1848c1b3555a9f5fc"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kiconthemes"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-ktextwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-kitemviews"

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
      #include <KXmlGuiWindow>
      int main() {
        KXmlGuiWindow win;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6XmlGui"
    system "./test"
  end
end
