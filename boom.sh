#!/bin/bash
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


# if test ! -f ~/.ssh/id_rsa ; then
#   ssh-keygen -t rsa -b 4096 -C "dominis@haxor.hu"
#   pbcopy < ~/.ssh/id_rsa.pub
#   echo "new public key copied to your clipboard"
#   echo "add it at https://github.com/settings/ssh"
#   read -p "press enter to continue"
#   ssh-keyscan github.com >> ~/.ssh/known_hosts
# fi

# if test ! -d ~/.dotfiles ; then
#   echo "installing dotfiles"
#   git clone git@github.com:dominis/dotfiles.git ~/.dotfiles
#   cd ~/.dotfiles
#   bash ./install.sh
#   bash ./.osx
# fi

# brew
brew doctor
brew update
brew upgrade
brew tap homebrew/dupes
brew tap homebrew/completions

binaries=(
  python
  tree
  ack
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
  gpg-agent
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

brew cleanup
brew prune
brew tap caskroom/cask

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
  torbrowser
  transmission
  vagrant
  virtualbox
  viscosity
  vlc
  xquartz
  yubikey-neo-manager
  yubikey-personalization-gui
  yubico-authenticator
  opera
  visual-studio-code
  signal
  moom
  remember-the-milk
  resilio-sync
  mac2imgur
  copyclip
)

echo "installing apps..."
brew cask cleanup
brew cask install --appdir="/Applications" ${apps[@]}

brew tap caskroom/versions

pips=(
  ansible
)

sudo easy_install pip
sudo -H pip install --upgrade pip
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
pip install ${pips[@]}

mackup restore -f

gem update --system
gem install ${gems[0]}
gem update

echo "system update"
sudo softwareupdate -i -a

