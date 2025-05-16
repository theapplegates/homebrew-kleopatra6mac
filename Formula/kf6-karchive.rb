class Kf6Karchive < Formula
  desc "Qt 6 addon providing access to numerous types of archives"
  homepage "https://invent.kde.org/frameworks/karchive"
  url "https://download.kde.org/stable/frameworks/6.14/karchive-6.14.0.tar.xz"
  sha256 "7c0b5fdd9171bc8e17f073f059c52b124274273c65c7b1e96f7e6d4d1b336b1a"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

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
      #include <KArchive>
      int main() { return 0; }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lKF6Archive"
    system "./test"
  end
end
