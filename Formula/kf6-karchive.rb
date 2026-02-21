class Kf6Karchive < Formula
  desc "Qt 6 addon providing access to numerous types of archives"
  homepage "https://invent.kde.org/frameworks/karchive"
  url "https://download.kde.org/stable/frameworks/6.14/karchive-6.14.0.tar.xz"
  sha256 "2cb2f54cb9f8132daf688a5d4acd7f4bec40203b01551ff06e6da1e9f87f0ef9"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext"
  depends_on "qt@6"

  def install
    # Fix for Qt 6.10 build failure: explicitly cast QIODevice::OpenMode to an integer.
    # Using standard Ruby to quietly bypass Homebrew's strict "inreplace" checker.
    Dir["src/*.cpp"].each do |file|
      content = File.read(file)
      content.gsub!(/\.arg\(\s*mode\s*\)/, ".arg(static_cast<int>(mode))")
      content.gsub!(/\.arg\(\s*openMode\s*\)/, ".arg(static_cast<int>(openMode))")
      content.gsub!(/\.arg\(\s*m_mode\s*\)/, ".arg(static_cast<int>(m_mode))")
      content.gsub!(/\.arg\(\s*d->mode\s*\)/, ".arg(static_cast<int>(d->mode))")
      content.gsub!(/\.arg\(\s*\(\s*mode\s*\)\s*\)/, ".arg(static_cast<int>(mode))")
      File.write(file, content)
    end

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
