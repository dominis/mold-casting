#!/bin/bash
set -x

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(/usr/bin/fdesetup isactive) == "false" ]]; then
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

mkdir -p ~/.ssh
echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> ~/.ssh/known_hosts

if [[ $(ssh -o BatchMode=yes git@github.com echo ok 2>&1) != "ok" ]]; then
  ssh-keygen -t rsa -b 4096 -C "dominis@haxor.hu"
  pbcopy < ~/.ssh/id_rsa.pub
  echo "new public key copied to your clipboard"
  echo "add it at https://github.com/settings/ssh"
  read -p "press enter to continue"
fi

# intall dotfiles
echo "installing dotfiles"
git clone git@github.com:dominis/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
./.osx

# brew
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
  bash_completion
)

echo "installing binaries..."
brew install ${binaries[@]}
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew cleanup
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

echo "please setup dropbox"
read -p "Press enter to continue"

sudo easy_install pip
sudo pip install mackup
mackup restore
