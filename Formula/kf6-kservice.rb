class Kf6Kservice < Formula
  desc "Plugin and service introspection – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kservice"
  url "https://download.kde.org/stable/frameworks/6.14/kservice-6.14.0.tar.xz"
  sha256 "9a840cf9ef7be78dfbb4bdbb201b37717489ddc579a202c54f97c3603d7f3192"
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
      #include <KService>
      int main() {
        KService::Ptr service = KService::serviceByDesktopName("org.kde.dolphin");
        return service ? 0 : 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6Service"
    system "./test"
  end
end
