class Kf6Kcoreaddons < Formula
  desc "Addons to QtCore – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kcoreaddons"
  url "https://download.kde.org/stable/frameworks/6.14/kcoreaddons-6.14.0.tar.xz"
  sha256 "d2d507c2ff8f034b8501976eb9895053dc5df30954b4073c93601c5be8ef3556"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt@6"
  depends_on "gettext"

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
      #include <KAboutData>
      int main() {
        KAboutData about("id", "name", "version");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lKF6CoreAddons"
    system "./test"
  end
end
