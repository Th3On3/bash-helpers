# ---------------------------------------
# setup/update_clean functions
# ---------------------------------------

function bh_setup_mac() {
  bh_log_func
  bh_install_mac_brew
  bh_brew_upgrade
  # essentials
  local pkgs="git bash $BH_PKGS_ESSENTIALS "
  # python
  pkgs+="python python-pip "
  bh_brew_install $pkgs
  # install vscode
  brew install --cask visual-studio-code
}

function bh_update_clean_mac() {
  # brew
  bh_brew_upgrade
  bh_brew_install $PKGS_BREW
  # python
  bh_python_install $PKGS_PYTHON
  # vscode
  bh_vscode_install $PKGS_VSCODE
  # cleanup
  bh_home_clean_unused
}

# ---------------------------------------
# brew functions
# ---------------------------------------

function bh_install_mac_brew() {
  bh_log_func
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

function bh_brew_install() {
  brew install "$@"
}

function bh_brew_upgrade() {
  brew update
  sudo brew upgrade
}