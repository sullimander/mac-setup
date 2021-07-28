#!/usr/bin/env bash

brewfiles=(*.Brewfile)

# Install command line tools
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "===== Installing Homebrew ====="
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo ""
echo "===== Updating Homebrew ====="
brew update

echo ""
echo "===== Tapping homebrew/bundle ====="
brew tap homebrew/bundle

echo ""
echo "===== Installing base packages ====="
brew bundle install

for b in ${brewfiles[@]}; do
  echo ""
  read -r -p "Do you want to install $b packages? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      echo "===== Installing $b packages =====";
      brew bundle install --file=$b;
      ;;
    *)
      echo "===== Skipping $b packages =====";
      ;;
  esac
done

echo ""
echo "===== Cleanup Homebrew ====="
brew cleanup

echo ""
read -r -p "Do you want to apply the settings in defaults.sh [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY])
    echo "===== Applying defaults.sh =====";
    source ./defaults.sh;
    ;;
  *)
    echo "===== Skipping defaults.sh =====";
    ;;
esac
