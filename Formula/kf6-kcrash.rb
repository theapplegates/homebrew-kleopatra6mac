class Kf6Kcrash < Formula
  desc "Graceful handling of application crashes – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kcrash"
  url "https://download.kde.org/stable/frameworks/6.14/kcrash-6.14.0.tar.xz"
  sha256 "dc86d226c06e4ec34ddc9ac4896a7f3c9a0a20e4d49e27f4a6e1719bc5fe0d35"
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
      #include <KCrash>
      int main() {
        KCrash::initialize();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6Crash"
    system "./test"
  end
end
