#!/bin/bash
set -e
set -x

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(/usr/bin/fdesetup isactive) == "false" ]]
then
  echo "failed, please enable full disk encryption (filevault) in system preferences"
  echo "http://support.apple.com/kb/ht4790"
  exit 1
fi

xcode-select --install
sleep 10
read -p "once it's installed press enter"
sudo xcodebuild -license

echo "install brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "install brew cask"
brew tap caskroom/cask

echo "system update"
sudo softwareupdate -i -a
