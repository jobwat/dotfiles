#!/bin/bash

echo "Install default packages list"

# Check if linux or mac
if [ `uname` = "Darwin" ]; then
  echo "Darwin"

  echo "Ensure brew installed"
  brew -h >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Install brew packages"
  cat packages.*.list | grep -v -e "^#" -e "debian" -e "cask$" -e "app-store" | sed "s/#.*//" | xargs -r brew install -q

  echo "Install brew casks"
  cat packages.*.list | grep -v -e "^#" | grep "brew.*cask" | sed "s/#.*//" | xargs -r brew install -q --cask

  echo "Install App store apps"
  cat packages.*.list | grep -v -e "^#" | grep "app-store" | sed "s/#.*//" | xargs -r mas install


else
  echo "Linux"

  cat packages.*.list | grep -v -e "^#" -e "brew" -e "cask$" -e "app-store" | sed "s/ .*//" | xargs sudo apt-get install -y

fi
