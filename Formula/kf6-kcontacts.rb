class Kf6Kcontacts < Formula
  desc "Address book API – KDE Frameworks 6"
  homepage "https://invent.kde.org/frameworks/kcontacts"
  url "https://download.kde.org/stable/frameworks/6.14/kcontacts-6.14.0.tar.xz"
  sha256 "4c73934eafc09d27dfb37f2d45b4db3e11bb49d83f2a42c3d58bcd01fe8aa99f"
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
      #include <KContacts/Addressee>
      int main() {
        KContacts::Addressee addr;
        addr.setName("Ada Lovelace");
        return addr.name().empty() ? 1 : 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{Formula["qt@6"].opt_include}",
           "-I#{include}",
           "-L#{lib}", "-lKF6Contacts"
    system "./test"
  end
end
