#!/usr/bin/env bash

# Script to install Kleopatra 24.02.2 with KDE Frameworks 6 and Qt 6 on macOS
# This script uses Homebrew

set -e  # Exit on error

echo "==== Kleopatra 24.02.2 Installer for macOS ===="
echo "This script will install Kleopatra 24.02.2 with KDE Frameworks 6 and Qt 6 support."
echo "It requires Homebrew to be installed."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
	echo "Error: Homebrew is not installed. Please install it first:"
	echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
	exit 1
fi

echo "Homebrew detected. Proceeding with installation..."

# Create temporary directory for the tap
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/theapplegates/homebrew-kleopatra6mac.git "$TEMP_DIR"

# Check architecture
if [[ $(uname -m) == "arm64" ]]; then
	ARCH="arm64"
	echo "Detected Apple Silicon (ARM64) architecture"
else
	ARCH="x86_64"
	echo "Detected Intel (x86_64) architecture"
fi

# Copy formula file to the repository
echo "Setting up the Homebrew formula..."
cp kleopatra.rb "$TEMP_DIR/"

# Navigate to temp directory and create a tap
cd "$TEMP_DIR"
HOMEBREW_TAP_DIR="$(brew --repository)/Library/Taps/homebrew/homebrew-kleopatra6mac"
mkdir -p "$(dirname "$HOMEBREW_TAP_DIR")"
mv "$TEMP_DIR" "$HOMEBREW_TAP_DIR"

echo "Created Homebrew tap: homebrew/kleopatra6mac"

# Make sure we have updated formulae
echo "Updating Homebrew..."
brew update

# Install dependencies
echo "Installing dependencies..."
brew install boost cmake extra-cmake-modules gettext kdoctools ninja pkg-config
brew install dbus gpgme iso-codes qt@6 libassuan libgpg-error pinentry-mac paperkey

# Update links for Qt6
echo "Setting up Qt 6..."
brew link --force qt@6

# Install Kleopatra
echo "Installing Kleopatra 24.02.2..."
brew install homebrew/kleopatra6mac/kleopatra

# Start dbus service
echo "Starting dbus service..."
brew services start dbus

# Setup pinentry-mac
echo "Setting up pinentry-mac..."
mkdir -p ~/.gnupg
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
killall -9 gpg-agent 2>/dev/null || true

# Create application link
echo "Creating application link in /Applications..."
ln -sf "$(brew --prefix)/opt/kleopatra/Applications/KDE/kleopatra.app" "/Applications/Kleopatra.app"

echo "==== Installation Complete ===="
echo "Kleopatra 24.02.2 has been installed."
echo ""
echo "To run Kleopatra, you can:"
echo "1. Open it from your Applications folder"
echo "2. Run 'kleopatra' in the terminal"
echo ""
echo "Note: If you encounter issues, make sure dbus is running:"
echo "  brew services start dbus"
echo ""
echo "Enjoy your secure communications with Kleopatra!"