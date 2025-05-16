class Kf6Kjobwidgets < Formula
  desc "Widgets for tracking asynchronous jobs – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kjobwidgets"
  url "https://download.kde.org/stable/frameworks/6.14/kjobwidgets-6.14.0.tar.xz"
  sha256 "e2f445373c3ecfce44b1b4c325180e4d57ed72514edb9477740ff8827f9278c6"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt@6"
  depends_on "gettext"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"

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
      #include <KJob>
      int main() {
        KJob *job = new KJob();
        return job ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6JobWidgets"
    system "./test"
  end
end
