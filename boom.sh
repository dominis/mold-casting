#!/bin/sh
set -x

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
  keybase
  pinentry
  pinentry-mac
  ssh-copy-id
  netcat
  socat
  udptunnel
  mackup
  zsh
)


echo "installing binaries..."
brew install ${binaries[@]} --with-default-names

apps=(
  1password
  caffeine
  coconutbattery
  evernote
  gpgtools
  handbrake
  iterm2-beta
  java
  numi
  send-to-kindle
  skype
  spotify
  textual
  tor-browser
  transmission
  vagrant
  virtualbox
  viscosity
  vlc
  xquartz
  opera
  visual-studio-code
  signal
  moom
  remember-the-milk
  resilio-sync
  mac2imgur
  copyclip
  yubico-authenticator
  yubico-yubikey-manager
  yubico-yubikey-piv-manager
  yubico-yubikey-personalization-gui
)

echo "installing apps..."
brew install --appdir="/Applications" ${apps[@]}

brew cleanup
brew prune

pips=(
  ansible
)

sudo easy_install pip
sudo -H pip install --upgrade pip
pip install ${pips[@]}

# Start gpg-agent to be able to ssh to github
pkill ssh-agent
gpgconf --launch gpg-agent
GPG_TTY=$(/usr/bin/tty)
SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
export GPG_TTY SSH_AUTH_SOCK

# Install dotfiles + mackup configs restore
if test ! -d ~/.dotfiles ; then
  echo "installing dotfiles"
  git clone git@github.com:dominis/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  sh ./install.sh
  sh ./.macos
  mackup restore -f
fi

# Make zsh to default shell
chsh -s /bin/zsh

echo "system update"
sudo softwareupdate -i -a
