# ---------------------------------------
# update_clean
# ---------------------------------------

function bh_update_clean_msys() {
  bh_log_func
  # windows
  if [ "$(bh_user_win_check_admin)" == "True" ]; then
    bh_syswin_update_win
  fi
  # winget (it uses --scope=user)
  bh_winget_install $BH_PKGS_WINGET
  # essentials
  local pkgs="pacman pacman-mirrors msys2-runtime vim diffutils curl $BH_PKGS_MSYS"
  # python
  pkgs+="python-pip "
  bh_msys_install $pkgs
  # python
  bh_python_install $BH_PKGS_PYTHON_MSYS
  bh_msys_upgrade
  # python
  bh_python_upgrade
  bh_python_install $BH_PKGS_PYTHON_MSYS
  # cleanup
  bh_home_clean_unused
}
