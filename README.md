# Kleopatra 24.02.2 for macOS (KF6/Qt6)

This repository provides a Homebrew formula and installation scripts for Kleopatra 24.02.2 on macOS, using KDE Frameworks 6 (KF6) and Qt 6. It's an updated version of the original [kleopatra4mac](https://github.com/algertc/homebrew-kleopatra4mac) project, which is no longer maintained.

## What is Kleopatra?

Kleopatra is a certificate manager and GUI for OpenPGP and CMS cryptography. It's part of the KDE software suite and provides tools for:

- Managing encryption keys (creating, importing, exporting)
- Encrypting and decrypting files and texts
- Signing and verifying data
- Working with smartcards and security tokens
- Connecting to key servers, LDAP, and WKD (Web Key Directory)

## System Requirements

- macOS Monterey (12.0) or newer
- [Homebrew](https://brew.sh/) package manager
- Sufficient disk space (~1GB) for all dependencies

## Installation

### Automatic Installation

The easiest way to install is using the provided script:

```bash
# Download the repository
git clone https://github.com/yourusername/homebrew-kleopatra6mac.git
cd homebrew-kleopatra6mac

# Make the script executable
chmod +x install-kleopatra.sh

# Run the installer
./install-kleopatra.sh
```

### Manual Installation

If you prefer to install manually:

1. Create a new Homebrew tap:
   ```bash
   mkdir -p $(brew --repository)/Library/Taps/homebrew/homebrew-kleopatra6mac
   cp kleopatra.rb $(brew --repository)/Library/Taps/homebrew/homebrew-kleopatra6mac/
   ```

2. Install the dependencies:
   ```bash
   brew install boost cmake extra-cmake-modules gettext kdoctools ninja pkg-config
   brew install dbus gpgme iso-codes qt@6 libassuan libgpg-error pinentry-mac paperkey
   brew link --force qt@6
   ```

3. Install Kleopatra:
   ```bash
   brew install homebrew/kleopatra6mac/kleopatra
   ```

4. Configure dbus and pinentry:
   ```bash
   brew services start dbus
   mkdir -p ~/.gnupg
   echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
   killall -9 gpg-agent
   ```

5. Create a link in your Applications folder:
   ```bash
   ln -sf "$(brew --prefix)/opt/kleopatra/Applications/KDE/kleopatra.app" "/Applications/Kleopatra.app"
   ```

## Running Kleopatra

After installation, you can run Kleopatra in two ways:

1. Open it from your Applications folder
2. Run `kleopatra` in the terminal

## Troubleshooting

If you encounter issues:

- Ensure dbus is running: `brew services start dbus`
- Check if pinentry-mac is correctly configured
- Make sure Qt 6 is properly linked: `brew link --force qt@6`
- Verify GnuPG is working: `gpg --version`

If you see dependency errors, you might need to install missing libraries:

```bash
brew install [missing-package]
```

## Building from Source

If you want to build the formula from source instead of using the prebuilt bottles:

```bash
brew install --build-from-source homebrew/kleopatra6mac/kleopatra
```

## Uninstalling

To uninstall Kleopatra:

```bash
brew uninstall kleopatra
rm "/Applications/Kleopatra.app"  # Remove the symlink
```

## Credits and License

- This project is an updated version of [kleopatra4mac](https://github.com/algertc/homebrew-kleopatra4mac)
- Kleopatra is developed by the KDE Community and is available under GPL and LGPL licenses
- This Homebrew formula is provided under the MIT license

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.