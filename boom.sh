#!/bin/sh
set -e

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $(/usr/bin/fdesetup isactive) == "false" ]]; then
  echo "please enable full disk encryption"
  echo "http://support.apple.com/kb/ht4790"
  exit 1
fi

echo "system update"
sudo softwareupdate -i -a
sudo softwareupdate --install-rosetta --agree-to-license

if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
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
  resilio-sync
  1password6
  caffeine
  coconutbattery
  handbrake
  iterm2-beta
  numi
  skype
  spotify
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
  mac2imgur
  bartender
  little-snitch
  zoom
  slack
  aws-vpn-client
  fsnotes
  google-chrome
  firefox
  logitech-camera-settings
  microsoft-teams
  protonmail-bridge
  rancher
  secretive
  session-manager-plugin
  adobe-creative-cloud
  mic-drop
)

echo "installing apps..."
brew install ${apps[@]} --cask

binaries=(
  python@3.7
  prthon@3.9
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
  tfenv
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
  gnupg
  ssh-copy-id
  netcat
  socat
  udptunnel
  mackup
  zsh
  golang
  minikube
  skaffold
  awscli
  azure-cli
  ffmpeg
  helm
  kubernetes-cli
  helm
  mitmproxy
  mtr
  node
  postgresql
  terraform-docs
  tree
  pre-commit
  fzf
  terraform-docs
  kube-ps1
  kubectx
  kompose
)

echo "installing utils..."
brew install ${binaries[@]}

# Make zsh to default shell
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
sudo chsh -s /bin/zsh

# brew cleanup
brew cleanup
brew prune

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

curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-social/hosts > /tmp/hosts

sudo cp /tmp/hosts /etc/hosts
