#!/bin/sh
set -e

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(/usr/bin/fdesetup isactive) == "false" ]]; then
  echo "please enable full disk encryption"
  echo "http://support.apple.com/kb/ht4790"
  exit 1
fi

if test ! $(which git); then
  echo "Installing commandline utils"
  xcode-select --install
  read -p "once it's installed press enter"
  sudo xcodebuild -license
fi

echo "system update"
sudo softwareupdate -i -a

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# brew
brew doctor
brew update
brew upgrade
brew tap homebrew/core
brew tap homebrew/cask
brew tap homebrew/cask-drivers
brew tap homebrew/cask-versions


apps=(
  remember-the-milk
  resilio-sync
  1password6
  caffeine
  coconutbattery
  evernote
  handbrake
  iterm2-beta
  numi
  send-to-kindle
  skype
  spotify
  textual
  tor-browser
  transmission
  viscosity
  vlc
  opera
  visual-studio-code
  signal
  moom
  mac2imgur
  copyclip
  yubico-authenticator
  yubico-yubikey-manager
  yubico-yubikey-piv-manager
  yubico-yubikey-personalization-gui
  docker
  vagrant
  virtualbox
  java
)

echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

binaries=(
  python
  tree
  git
  git-crypt
  nmap
  curl
  coreutils
  findutils
  diffutils
  git-extras
  binutils
  gzip
  git
  terraform
  packer
  wget
  watch
  screen
  gzip
  grep
  gnu-indent
  gnu-sed
  gnu-tar
  gnu-which
  gnutls
  file-formula
  less
  openssh
  unzip
  gpg
  jq
  ykpers
  yubico-piv-tool
  gnupg
  pinentry
  pinentry-mac
  ssh-copy-id
  netcat
  socat
  udptunnel
  mackup
  zsh
  golang
)

echo "installing utils..."
brew install ${binaries[@]} --with-default-names

# Make zsh to default shell
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
sudo chsh -s /bin/zsh

# brew cleanup
brew cleanup
brew prune

pips=(
  ansible
)

sudo easy_install pip
sudo -H pip install --upgrade pip
sudo pip install ${pips[@]}


# Get stuff from resilio sync
read -p "Please run resilio sync. Done? (Yn) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cp -r ~/Sync/Mackup/.mackup* ~/
  mackup restore -f
fi
unset $REPLY

# Download and run macos settings
curl -s https://raw.githubusercontent.com/dominis/mold-casting/master/macos > /tmp/macos
sh /tmp/macos
