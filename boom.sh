#!/bin/bash
set -x

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(/usr/bin/fdesetup isactive) == "false" ]]
then
  echo "please enable full disk encryption"
  echo "http://support.apple.com/kb/ht4790"
  exit 1
fi

echo "system update"
sudo softwareupdate -i -a

if test ! $(which git); then
  echo "Installing commandline utils"
  xcode-select --install
  read -p "once it's installed press enter"
  sudo xcodebuild -license
fi

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

binaries=(
  python
  tree
  ack
  hub
  git
  git-crypt
  nmap
  pwgen
  curl
  dos2unix
  gnu-tar
  coreutils
  findutils
  diffutils
  bash
  git-extras
  binutils
  gzip
  git
)

echo "installing binaries..."
brew install ${binaries[@]}

brew tap homebrew/dupes
brew install homebrew/dupes/grep

brew cleanup

echo "install brew cask"
brew tap caskroom/cask

apps=(
  dropbox
  google-chrome
  slack
  spotify
  vagrant
  iterm2
  sublime-text3
  virtualbox
  tower
  vlc
  skype
  transmission
  1password
  caffeine
  google-drive
  handbrake
  numi
  spotifree
  vagrant-bar
  cocounutbattery
)

echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

brew tap caskroom/versions

read -p "Please set up dropbox"



sudo pip install mackup
mackup restore
