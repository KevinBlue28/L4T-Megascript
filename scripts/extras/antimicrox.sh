#!/bin/bash

if command -v apt >/dev/null; then

  case "$__os_codename" in
  bionic | focal)
    ubuntu_ppa_installer "okirby/qt6-backports"
    ;;
  esac

  sudo apt install -y git build-essential cmake extra-cmake-modules \
    qt6-base-dev qt6-tools-dev libsdl2-dev \
    libqt6core5compat6-dev qt6-l10n-tools \
    libxi-dev libxtst-dev libx11-dev itstool gettext python3-libxml2 || error "Could not install dependencies"

  hash -r

  # Cloning
  cd /tmp || error "No /tmp directory"
  rm -rf antimicrox
  git clone https://github.com/AntiMicroX/antimicrox.git --depth=1
  cd antimicrox
  mkdir build && cd build

  # Building
  cmake .. || error "Cmake failed"
  make -j$(nproc) || error "Compilation failed"

  # Installing
  sudo make install || error "Make install failed"

  # Removing source
  cd ~
  rm -rf /tmp/antimicrox

elif command -v dnf >/dev/null; then
  sudo dnf install -y --refresh antimicrox || error "Failed to install AntiMicroX!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done!"
sleep 1
