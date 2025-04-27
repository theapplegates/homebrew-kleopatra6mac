class Kleopatra < Formula
  desc "Certificate manager and GUI for OpenPGP and CMS cryptography"
  homepage "https://invent.kde.org/pim/kleopatra"
  url "https://download.kde.org/stable/release-service/24.02.2/src/kleopatra-24.02.2.tar.xz"
  sha256 "83c2af4f4e4d8f98aeafdf5b2d576e07ac599db1e9bd2e64cbabce6a6a2a8b8d"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  keg_only "not linked to prevent conflicts with any gpgme or kde libs"

  # This is where you would normally define bottles, but we'll leave this empty initially
  # bottle do
  #   root_url "https://github.com/yourusername/homebrew-kleopatra4mac/releases/download/latest"
  #   sha256 ventura: "PLACEHOLDER_HASH_VALUE"
  #   sha256 monterey: "PLACEHOLDER_HASH_VALUE"
  #   sha256 arm64_ventura: "PLACEHOLDER_HASH_VALUE"
  #   sha256 arm64_monterey: "PLACEHOLDER_HASH_VALUE"
  # end

  # Build dependencies
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "gettext" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  # Runtime dependencies - KF6 and Qt6
  depends_on "dbus"
  depends_on "gpgme"
  depends_on "iso-codes"
  depends_on "karchive"
  depends_on "kcodecs"
  depends_on "kconfig"
  depends_on "kconfigwidgets"
  depends_on "kcoreaddons"
  depends_on "kcrash"
  depends_on "kdbusaddons"
  depends_on "ki18n"
  depends_on "kiconthemes"
  depends_on "kio"
  depends_on "kitemmodels"
  depends_on "kmime"
  depends_on "knotifications"
  depends_on "kstatusnotifieritem"
  depends_on "kwidgetsaddons"
  depends_on "kwindowsystem"
  depends_on "kxmlgui"
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libkleo"
  depends_on "pinentry-mac"
  depends_on "qt"
  
  # Optional but recommended
  depends_on "paperkey" => :recommended

  def install
    # Enable support for gpgme++
    ENV["LDFLAGS"] = "-L#{Formula["gpgme"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{Formula["gpgme"].opt_include}"
    ENV["PKG_CONFIG_PATH"] = "#{Formula["gpgme"].opt_lib}/pkgconfig"
    
    # Set Qt6 as the version to use
    ENV["CMAKE_PREFIX_PATH"] = "#{Formula["qt"].opt_prefix}/lib/cmake"
    
    # Configure with KF6 and Qt6
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DKDE_INSTALL_PLUGINDIR=#{lib}/qt6/plugins
      -DKDE_INSTALL_QTPLUGINDIR=#{lib}/qt6/plugins
      -DKDE_INSTALL_LIBEXECDIR=#{libexec}
      -DBUILD_TESTING=OFF
      -DKDE_INSTALL_BUNDLEDIR=#{bin}
      -DQT_MAJOR_VERSION=6
      -DBUILD_WITH_QT6=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    # Create app bundle for macOS
    app_dir = "#{prefix}/Applications/KDE/kleopatra.app"
    bin_dir = "#{bin}"
    
    # Ensure application is properly bundled
    mkdir_p "#{bin_dir}"
    
    # Create wrapper script for launching
    (bin_dir/"kleopatra").write <<~EOS
      #!/bin/bash
      #{app_dir}/Contents/MacOS/kleopatra "$@"
    EOS
    
    chmod 0755, "#{bin_dir}/kleopatra"
    
    # Add runtime paths to ensure libraries can be found
    kleopatra_bin = "#{app_dir}/Contents/MacOS/kleopatra"
    if File.exist?(kleopatra_bin)
      system "install_name_tool", "-add_rpath", "#{prefix}/lib", kleopatra_bin
      system "install_name_tool", "-add_rpath", "#{HOMEBREW_PREFIX}/lib", kleopatra_bin
      system "install_name_tool", "-add_rpath", "#{Formula["qt"].opt_lib}", kleopatra_bin
    end
  end

  test do
    k = "#{prefix}/Applications/KDE/kleopatra.app/Contents/MacOS/kleopatra"
    system k, "--help"
  end

  def caveats
    <<~EOS
      After Installing:

      Make sure dbus is running
        brew services start dbus

      Select pinentry-mac as the default program
        brew install pinentry-mac
        echo "pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
        killall -9 gpg-agent

      To run Kleopatra:
        kleopatra

      If you want to add this application to the Launchpad, you can do:
        ln -sf "#{prefix}/Applications/KDE/kleopatra.app" "/Applications/Kleopatra.app"
    EOS
  end
end
