#!/usr/bin/env bash

# Script to set up the homebrew-kleopatra6mac repository structure
# This script should be run once to initialize the repository

set -e  # Exit on error

echo "==== Setting up Kleopatra 24.02.2 Homebrew Tap Repository ===="

# Create directory structure
mkdir -p Formula
mkdir -p scripts
mkdir -p bottles

# Move files to appropriate locations
cp kleopatra.rb Formula/
cp install-kleopatra.sh scripts/
chmod +x scripts/install-kleopatra.sh

# Create a .gitignore file
cat > .gitignore << EOF
.DS_Store
*.swp
*~
bottles/*.tar.gz
EOF

# Create initial GitHub Actions workflow for CI
mkdir -p .github/workflows
cat > .github/workflows/build.yml << EOF
name: Build and Test

on:
  push:
	branches: [ main ]
  pull_request:
	branches: [ main ]

jobs:
  build:
	runs-on: macos-latest
	steps:
	- uses: actions/checkout@v2
	
	- name: Set up Homebrew
	  run: |
		brew update
	
	- name: Install and audit formula
	  run: |
		mkdir -p \$(brew --repository)/Library/Taps/homebrew/homebrew-kleopatra6mac
		cp Formula/kleopatra.rb \$(brew --repository)/Library/Taps/homebrew/homebrew-kleopatra6mac/
		brew audit --strict homebrew/kleopatra6mac/kleopatra
		brew install --only-dependencies homebrew/kleopatra6mac/kleopatra
		# Skip actual installation for CI, just verify dependencies
EOF

# Create an examples directory with a sample gpg.conf
mkdir -p examples
cat > examples/gpg.conf << EOF
# Sample gpg.conf file for use with Kleopatra
# Copy to ~/.gnupg/gpg.conf and modify as needed

# Get regular key info
keyserver hkps://keys.openpgp.org
keyserver-options auto-key-retrieve

# When creating new keys
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
cert-digest-algo SHA512

# Misc settings
no-greeting
no-emit-version
EOF

echo "==== Repository Setup Complete ===="
echo ""
echo "Next steps:"
echo "1. Initialize git repository:    git init"
echo "2. Add all files:                git add ."
echo "3. Make initial commit:          git commit -m 'Initial commit'"
echo "4. Create GitHub repository:     gh repo create yourusername/homebrew-kleopatra6mac --public"
echo "5. Push to GitHub:               git push -u origin main"
echo ""
echo "Then, users can tap your repository with:"
echo "  brew tap yourusername/homebrew-kleopatra6mac"
echo "  brew install kleopatra"