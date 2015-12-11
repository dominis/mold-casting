#!/bin/bash
set -e
set -x

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

