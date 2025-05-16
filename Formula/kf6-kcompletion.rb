class Kf6Kcompletion < Formula
  desc "Text completion helpers and widgets"
  homepage "https://invent.kde.org/frameworks/kcompletion"
  url "https://download.kde.org/stable/frameworks/6.14/kcompletion-6.14.0.tar.xz"
  sha256 "e0cc38544e7d0f3f1b4ab3c2c3830ecfc0c18e48c3bb4577db69a41f4cc0a5fc"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
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
      #include <KCompletion>
      int main() {
        KCompletion comp;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lKF6Completion"
    system "./test"
  end
end
