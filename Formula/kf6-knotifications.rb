class Kf6Knotifications < Formula
  desc "Abstraction for system notifications – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/knotifications"
  url "https://download.kde.org/stable/frameworks/6.14/knotifications-6.14.0.tar.xz"
  sha256 "ffdd6822876b8e372d9c9985bcd5dc93b7c7fc89ac22c89a32dbb23510e75b44"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
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
      #include <KNotification>
      int main() {
        KNotification::event(KNotification::Notification, "Test message");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6Notifications"
    system "./test"
  end
end
