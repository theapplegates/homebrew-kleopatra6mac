class Kf6Kio < Formula
  desc "Resource and network abstraction – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kio"
  url "https://download.kde.org/stable/frameworks/6.14/kio-6.14.0.tar.xz"
  sha256 "2d06a0f85d4f66e1c0aa6c5b6f58637967b1843f8f6b2e3cf33ebf2c177d5d25"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kcompletion"
  depends_on "theapplegates/kleopatra6mac/kf6-kiconthemes"
  depends_on "theapplegates/kleopatra6mac/kf6-kjobwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-kservice"
  depends_on "theapplegates/kleopatra6mac/kf6-kcrash"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfigwidgets"

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
      #include <KIO/Job>
      int main() {
        KIO::Job *job = KIO::get(QUrl("http://example.com"));
        return job ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6KIOCore"
    system "./test"
  end
end
