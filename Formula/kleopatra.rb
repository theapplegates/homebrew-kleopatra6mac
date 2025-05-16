class Kleopatra < Formula
  desc "Certificate Manager and GUI for OpenPGP and CMS cryptography"
  homepage "https://apps.kde.org/kleopatra/"
  url "https://download.kde.org/stable/release-service/24.02.2/src/kleopatra-24.02.2.tar.xz"
  sha256 "your_actual_sha256_here"
  license "GPL-2.0-or-later"

  # Build dependencies
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext" => :build
  depends_on "qt@6" => :build
  depends_on "kdoctools"
  depends_on "kdoctools" => :build

  # Runtime dependencies - Qt6 and KDE Frameworks 6
  depends_on "qt@6"
  depends_on "theapplegates/kleopatra6mac/kf6-karchive"
  depends_on "theapplegates/kleopatra6mac/kf6-kcompletion"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfig"
  depends_on "theapplegates/kleopatra6mac/kf6-kconfigwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-kcoreaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kiconthemes"
  depends_on "theapplegates/kleopatra6mac/kf6-kio"
  depends_on "theapplegates/kleopatra6mac/kf6-kitemviews"
  depends_on "theapplegates/kleopatra6mac/kf6-kjobwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-knotifications"
  depends_on "theapplegates/kleopatra6mac/kf6-kservice"
  depends_on "theapplegates/kleopatra6mac/kf6-kstatusnotifieritem"
  depends_on "theapplegates/kleopatra6mac/kf6-ktextwidgets"
  depends_on "theapplegates/kleopatra6mac/kf6-kwidgetsaddons"
  depends_on "theapplegates/kleopatra6mac/kf6-kxmlgui"
  depends_on "theapplegates/kleopatra6mac/kf6-kcmutils"
  depends_on "theapplegates/kleopatra6mac/kf6-kcontacts"

  # PIM and crypto dependencies
  depends_on "gpgme"
  depends_on "theapplegates/kleopatra6mac/kf6-gpgme"
  depends_on "kde/homebrew-kde/libkleo"
  depends_on "mimetreeparser"
  depends_on "kmime"

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DKDE_INSTALL_BUNDLEDIR=#{bin}
      -DKDE_INSTALL_QMLDIR=#{lib}/qt6/qml
      -DKDE_INSTALL_PLUGINDIR=#{lib}/qt6/plugins
    ]

    system "cmake", ".", *args
    system "ninja", "install"
  end

  test do
    assert_match "kleopatra", shell_output("#{bin}/kleopatra --help")
  end
end
