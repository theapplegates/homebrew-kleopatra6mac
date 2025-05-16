class Kf6Kitemviews < Formula
  desc "Widgets for item models – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kitemviews"
  url "https://download.kde.org/stable/frameworks/6.14/kitemviews-6.14.0.tar.xz"
  sha256 "d58e6822a3cf09d15b68ed004cc0f9b6ed2aebdc1c2b612f0ae77cd1858db64d"
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
      #include <KItemViews/KItemViewSearchLine>
      int main() {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6ItemViews"
    system "./test"
  end
end
