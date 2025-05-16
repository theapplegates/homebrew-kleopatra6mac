class Gpgme < Formula
  desc "GnuPG Made Easy (GPGME) library"
  homepage "https://gnupg.org/software/gpgme/"
  url "file:///#{Dir.pwd}/gpgme-1.24.2.tar.bz2"
  sha256 "4a9477c0a1555f3f6b158d689bd8ecb174ff7de18a24dd213378e328ea30d264"
  license "LGPL-2.1-or-later"

  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "gettext"
  depends_on "qt@6"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-qt6"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gpgme.h>
      int main() {
        gpgme_check_version(NULL);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lgpgme"
    system "./test"
  end
end
