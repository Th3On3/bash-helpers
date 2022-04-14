# ---------------------------------------
# gnome
# ---------------------------------------

function gnome_sanity() {
  gnome_dark
  gnome_sanity
  gnome_disable_unused_apps_in_search
  gnome_disable_super_workspace_change
}

function gnome_uninstall_desktop_unused() {
  local pkgs_apt_remove_ubu+="libreoffice-* mpv yad ubuntu-report ubuntu-web-launchers mercurial nano zathura simple-scan xterm devhelp thunderbird remmina zeitgeist plymouth evolution-plugins evolution-common fwupd gnome-todo aisleriot gnome-user-guide gnome-mahjongg gnome-weather gnome-mines gnome-sudoku cheese gnome-calendar rhythmbox deja-dup evolution empathy gnome-music gnome-maps gnome-photos totem gnome-orca gnome-getting-started-docs gnome-logs gnome-color-manager gucharmap seahorse gnome-accessibility-themes brasero transmission-gtk "
  apt_remove_pkgs $pkgs_apt_remove_ubu
}

function gnome_execute_desktop_file() {
  awk '/^Exec=/ {sub("^Exec=", ""); gsub(" ?%[cDdFfikmNnUuv]", ""); exit system($0)}' $1
}

function gnome_reset_keybindings() {
  gsettings reset-recursively org.gnome.mutter.keybindings
  gsettings reset-recursively org.gnome.mutter.wayland.keybindings
  gsettings reset-recursively org.gnome.desktop.wm.keybindings
  gsettings reset-recursively org.gnome.shell.keybindings
  gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys
}

function gnome_dark_mode() {
  gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-Black'
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
}

function gnome_dark_desktop_background() {
  # desktop
  gsettings set org.gnome.desktop.background color-shading-type "solid"
  gsettings set org.gnome.desktop.background picture-uri ''
  gsettings set org.gnome.desktop.background primary-color "#000000"
  gsettings set org.gnome.desktop.background secondary-color "#000000"
}

function gnome_sanity() {
  # gnome search
  gsettings set org.gnome.desktop.search-providers sort-order "[]"
  gsettings set org.gnome.desktop.search-providers disable-external false
  gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.clocks.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']"
  # animation
  gsettings set org.gnome.desktop.interface enable-animations false
  # desktop
  gsettings set org.gnome.desktop.background show-desktop-icons false
  # cloack
  gsettings set org.gnome.desktop.interface clock-show-date true
  # notifications
  gsettings set org.gnome.desktop.notifications show-banners false
  gsettings set org.gnome.desktop.notifications show-in-lock-screen false
  # recent files
  gsettings set org.gnome.desktop.privacy remember-recent-files false
  # screensaver
  gsettings set org.gnome.desktop.screensaver color-shading-type "solid"
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.screensaver picture-uri ''
  gsettings set org.gnome.desktop.screensaver primary-color "#000000"
  gsettings set org.gnome.desktop.screensaver secondary-color "#000000"
  # sound
  gsettings set org.gnome.desktop.sound event-sounds false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
  # gedit
  gsettings set org.gnome.gedit.preferences.editor bracket-matching true
  gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
  gsettings set org.gnome.gedit.preferences.editor display-right-margin true
  gsettings set org.gnome.gedit.preferences.editor scheme 'classic'
  gsettings set org.gnome.gedit.preferences.editor wrap-last-split-mode 'word'
  gsettings set org.gnome.gedit.preferences.editor wrap-mode 'word'
  # workspaces
  gsettings set org.gnome.mutter dynamic-workspaces false
  # nautilus
  gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
  gsettings set org.gnome.nautilus.list-view use-tree-view true
  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
  gsettings set org.gnome.nautilus.window-state maximized false
  gsettings set org.gnome.nautilus.window-state sidebar-width 180
  # dock
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
  gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
  gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
  gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button false
}

function gnome_disable_unused_apps_in_search() {
  local apps_to_hide=$(find /usr/share/applications/ -iname '*im6*' -iname '*java*' -o -iname '*JB*' -o -iname '*policy*' -o -iname '*icedtea*' -o -iname '*uxterm*' -o -iname '*display-im6*' -o -iname '*unity*' -o -iname '*webbrowser-app*' -o -iname '*amazon*' -o -iname '*icedtea*' -o -iname '*xdiagnose*' -o -iname yelp.desktop -o -iname '*brasero*')
  for i in $apps_to_hide; do
    sudo sh -c " echo 'NoDisplay=true' >> $i"
  done
}

function gnome_disable_super_workspace_change() {
  # remove super+arrow virtual terminal change
  sudo sh -c 'dumpkeys |grep -v cr_Console |loadkeys'
}

function gnome_disable_tiling() {
  # disable tiling
  gsettings set org.gnome.mutter edge-tiling false
}

function gnome_reset_tracker() {
  sudo tracker reset --hard
  sudo tracker daemon -s
}

function gnome_reset_shotwell() {
  rm -r $HOME/.cache/shotwell $HOME/.local/share/shotwell
}

function gnome_update_desktop_database() {
  sudo update-desktop-database -v /usr/share/applications $HOME/.local/share/applications $HOME/.gnome/apps/
}

function gnome_update_icons() {
  sudo update-icon-caches -v /usr/share/icons/ $HOME/.local/share/icons/
}

function gnome_version() {
  gnome-shell --version
  mutter --version | head -n 1
  gnome-terminal --version
  gnome-text-editor --version
}

function gnome_gdm_restart() {
  sudo /etc/setup.d/gdm3 restart
}

function gnome_settings_reset() {
  : ${1?"Usage: ${FUNCNAME[0]} <scheme>"}
  gsettings reset-recursively $1
}

function gnome_settings_save_to_file() {
  : ${2?"Usage: ${FUNCNAME[0]} <dconf-dir> <file_name>"}
  dconf dump $1 >$2
}

function gnome_settings_load_from_file() {
  : ${1?"Usage: ${FUNCNAME[0]} <dconf-dir> <file_name>"}
  dconf load $1 <$2
}

function gnome_settings_diff_actual_and_file() {
  : ${2?"Usage: ${FUNCNAME[0]} <dconf-dir> <file_name>"}
  local tmp_file=/tmp/gnome_settings_diff
  gnome_settings_save_to_file $1 $tmp_file
  diff $tmp_file $2
}