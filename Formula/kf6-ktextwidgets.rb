class Kf6Ktextwidgets < Formula
  desc "Text editing widgets – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/ktextwidgets"
  url "https://download.kde.org/stable/frameworks/6.14/ktextwidgets-6.14.0.tar.xz"
  sha256 "1246b81ff97cf031d8f4e1dbdf2c6621c260b63b3ec35c8d193f25f0ef8b5f8b"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfigwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kiconthemes"
  depends_on "theapplegates/kleopatra6mac/kf6-kcompletion"

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
      #include <KTextEdit>
      int main() {
        KTextEdit *edit = new KTextEdit();
        return edit ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6TextWidgets"
    system "./test"
  end
end
