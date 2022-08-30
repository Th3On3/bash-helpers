alias ls='ls --color=auto --hide=ntuser* --hide=NTUSER* --hide=AppData --hide=IntelGraphicsProfiles* --hide=MicrosoftEdgeBackups'

function win_clean_trash() {
  powershell -c 'Clear-RecycleBin -Confirm:$false 2> $null'
}

function win_open_trash() {
  powershell -c 'Start-Process explorer shell:recyclebinfolder'
}

function win_restart_explorer() {
  powershell -c 'taskkill /f /im explorer | Out-Null; Start-Process explorer'
}

function win_open_tmp() {
  powershell -c 'Start-Process explorer "${env:localappdata}\\temp\'
}

function win_hide_home_dotfiles() {
  powershell -c 'Get-ChildItem "${env:userprofile}\\.*" | ForEach-Object { $_.Attributes += "Hidden" }'
}

function win_is_user_admin() { # ex: if [ $(win_is_user_admin) = "True" ]; then win_get_install "gerardog.gsudo"; fi
  powershell -c ' (Get-LocalGroupMember "Administrators").Name -contains "$env:COMPUTERNAME\$env:USERNAME" '
}

function win_is_shell_eleveated() { # return True/False
  powershell -c '(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)'
}

# ---------------------------------------
# sys
# ---------------------------------------

function win_sys_check() {
  gsudo powershell -c 'sfc /scannow'
}

function win_sys_update() {
  gsudo powershell -c '
    Install-Module -Name PSWindowsUpdate -Force
    Install-WindowsUpdate -AcceptAll -IgnoreReboot
  '
}

function win_sys_update_list() {
  gsudo powershell -c 'Get-WindowsUpdate'
}

function win_sys_feature_list_enabled() {
  gsudo powershell -c 'Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"}'
}

function win_sys_feature_list_disabled() {
  gsudo powershell -c 'Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Disabled"}'
}

function win_sys_feature_enable_ssh_server_bash() {
  local current_bash_path=$(where bash | head -1)
  gsudo powershell -c "
    Add-WindowsCapability -Online -Name OpenSSH.Client
    Add-WindowsCapability -Online -Name OpenSSH.Server
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value '$current_bash_path' -PropertyType String -Force
  "
}

# ---------------------------------------
# appx
# ---------------------------------------

function win_appx_list() {
  gsudo powershell -c "Get-AppxPackage -AllUsers | Select-Object Name, PackageFullName"
}

function win_appx_uninstall() {
  gsudo powershell -c '
  if (Get-AppxPackage -Name ' "$1" ') {
    Get-AppxPackage' "$1" '| Remove-AppxPackage
  }
  '
}

function win_appx_install() {
  gsudo powershell -c '
    Get-AppxPackage ' "$1" '| ForEach-Object { Add-AppxPackage -ea 0 -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" } | Out-null
  '
}

# ---------------------------------------
# env
# ---------------------------------------

function win_env_show() {
  powershell -c 'Get-ChildItem Env:'
}

function win_env_add() {
  : ${2?"Usage: ${FUNCNAME[0]} <varname> <value>"}
  powershell -c "[System.Environment]::SetEnvironmentVariable('$1', '$2', 'user')"
}

# ---------------------------------------
# path
# ---------------------------------------

function win_path_show() {
  powershell -c '(Get-ChildItem Env:Path).Value'
}

function win_path_show_as_list() {
  IFS=';' read -ra ADDR <<<$(win_path_show)
  for i in "${!ADDR[@]}"; do echo ${ADDR[$i]}; done
}

function win_path_add() {
  local dir=$(cygpath -w $@)
  powershell -c ' 
    function win_path_add($addDir) {
      $currentpath = [System.Environment]::GetEnvironmentVariable("PATH", "user")
      $regexAddPath = [regex]::Escape($addDir)
      $arrPath = $currentpath -split ";" | Sort-Object -Unique | Where-Object { $_ -notMatch "^$regexAddPath\\?" }
      $newpath = ($arrPath + $addDir) -join ";"
      [System.Environment]::SetEnvironmentVariable("PATH", $newpath, "user")
    }; win_path_add ' \"$dir\"
}

function win_path_rm() {
  local dir=$(cygpath -w $@)
  powershell -c ' 
    function win_path_rm($remDir) {
      $currentpath = [System.Environment]::GetEnvironmentVariable("PATH", "user")
      $newpath = ($currentpath.Split(";") | Where-Object { $_ -ne "$remDir" }) -join ";"
      [System.Environment]::SetEnvironmentVariable("PATH", $newpath, "user")
    }; win_path_rm ' \"$dir\"
}

# ---------------------------------------
# install
# ---------------------------------------

function win_install_python() {
  winget install Python.Python.3 --source winget -i
  win_path_add $(cygpath -w $HOME/AppData/Local/Programs/Python/Python310/Scripts/)
  win_path_add $(cygpath -w $HOME/AppData/Roaming/Python/Python310/Scripts/)
}

function win_install_miktex() {
  win_get_install ChristianSchenk.MiKTeX
  win_path_add $(cygpath -w $HOME/AppData/Local/Programs/MiKTeX/miktex/bin/x64/)
}

function win_install_gitbash() {
  powershell $(cygpath -w $BH_DIR/plugins/ps1/install-gitbash.ps1)
}

function win_install_msys2() {
  powershell $(cygpath -w $BH_DIR/plugins/ps1/install-msys2.ps1)
}

function win_install_ghostscript() {
  win_get_install ArtifexSoftware.GhostScript
  win_path_add $(cygpath -w '/c/Program Files/gs/gs9.55.0/bin')
}

function win_install_vscode() {
  win_get_install Microsoft.VisualStudioCode
}

function win_install_cmake() {
  win_get_install Kitware.CMake
}

function win_install_wget() {
  win_get_install GnuWin32.Wget
}

function win_install_tree() {
  GnuWin32.Tree
}

function win_install_node() {
  winget install OpenJS.NodeJS
}

BH_PLATOOLS_VER="31.0.3-windows"

function win_install_adb() {
  # android plataform tools
  local android_sdk_dir=$(cygpath $LOCALAPPDATA/Android/Sdk)
  test_and_create_dir $android_sdk_dir
  local android_plattools_dir="$android_sdk_dir/platform-tools"
  local android_plattools_url="https://dl.google.com/android/repository/platform-tools_r${BH_PLATOOLS_VER}.zip"
  if ! test -d $android_plattools_dir; then
    decompress_from_url $android_plattools_url $android_sdk_dir
    if test $? != 0; then log_error "decompress_from_url failed." && return 1; fi
  fi
  win_path_add $(cygpath -w $android_plattools_dir)
}

BH_ANDROID_CMD_VER="8512546"
BH_SDK_VER="33"

function win_install_android_sdk() {
  # android cmd and sdk
  local android_sdk_dir=$(cygpath $LOCALAPPDATA/Android/Sdk)
  test_and_create_dir $android_sdk_dir
  local android_cmd_dir="$android_sdk_dir/cmdline-tools"
  local android_cmd_url="https://dl.google.com/android/repository/commandlinetools-win-${BH_ANDROID_CMD_VER}_latest.zip"
  if ! test -d $android_cmd_dir; then
    decompress_from_url $android_cmd_url $android_sdk_dir
    if test $? != 0; then log_error "decompress_from_url failed." && return 1; fi
    win_path_add $(cygpath -w $android_cmd_dir/bin)
  fi
  if ! test -d "$android_sdk_dir/platforms/android-$BH_SDK_VER"; then
    $android_cmd_dir/bin/sdkmanager.bat --sdk_root="$android_sdk_dir" --install  "platform-tools" "platforms;android-$BH_SDK_VER"
    yes | $android_cmd_dir/bin/sdkmanager.bat --sdk_root="$android_sdk_dir" --licenses
  fi
  win_env_add ANDROID_HOME $(cygpath -w $android_sdk_dir)
  win_env_add ANDROID_SDK_ROOT $(cygpath -w $android_sdk_dir)
  win_path_add $(cygpath -w $android_sdk_dir/platform-tools)
}

BH_FLUTTER_VER="3.0.5"

function win_install_flutter() {
  local opt_dst="$BH_OPT"
  local flutter_sdk_dir="$BH_OPT/flutter"
  local flutter_sdk_url="https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_${BH_FLUTTER_VER}-stable.zip"
  if ! test -d $flutter_sdk_dir; then
    # opt_dst beacuase zip extract the flutter dir
    decompress_from_url $flutter_sdk_url $opt_dst
    if test $? != 0; then log_error "decompress_from_url failed." && return 1; fi
  fi
  win_path_add $(cygpath -w $flutter_sdk_dir/bin)
}

function win_install_tesseract() {
  if ! type tesseract.exe &>/dev/null; then
    win_get_install tesseract
    win_path_add 'C:\Program Files\Tesseract-OCR'
  fi
}

function win_install_java() {
  if ! type java.exe &>/dev/null; then
    win_get_install ojdkbuild.ojdkbuild
    local javahome=$(powershell -c '$(get-command java).Source.replace("\bin\java.exe", "")')
    env_add "JAVA_HOME" "$javahome"
  fi
}

function win_install_gsudo() {
  win_get_install gsudo
}

function win_install_wsl() {
  gsudo powershell $(cygpath -w $BH_DIR/plugins/ps1/install-wsl.ps1)
}

function win_install_docker() {
  gsudo powershell -c Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V") -All
  gsudo powershell -c Enable-WindowsOptionalFeature -Online -FeatureName $("Containers") -All
  win_get_install Docker.DockerDesktop
}

# ---------------------------------------
# winget
# ---------------------------------------

function win_get_list() {
  winget list
}

function win_get_settings() {
  winget settings
}

function win_get_upgrade() {
  winget upgrade --all --silent
}

function win_get_install() {
  local pkgs_to_install=""
  for i in "$@"; do
    if [[ $(winget list --id $i) =~ "No installed"* ]]; then
      pkgs_to_install="$i $pkgs_to_install"
    fi
  done
  if test ! -z "$pkgs_to_install"; then
    echo "pkgs_to_install=$pkgs_to_install"
    for pkg in $pkgs_to_install; do
      winget install $pkg
    done
  fi
}

# ---------------------------------------
# sanity
# ---------------------------------------

function win_sanity_ui() {
  powershell $(cygpath -w $BH_DIR/plugins/ps1/sanity-ui.ps1)
}

function win_sanity_ctx_menu() {
  gsudo powershell $(cygpath -w $BH_DIR/plugins/ps1/sanity-cxt-menu.ps1)
}

function win_sanity_services() {
  gsudo powershell $(cygpath -w $BH_DIR/plugins/ps1/sanity-services.ps1)
}

function win_sanity_password_policy() {
  gsudo powershell $(cygpath -w $BH_DIR/plugins/ps1/sanity-password-policy.ps1)
}

function win_sanity_this_pc() {
  gsudo powershell $(cygpath -w $BH_DIR/plugins/ps1/sanity-this-pc.ps1)
}

function win_sanity_all() {
  win_sanity_ui
  win_sanity_ctx_menu
  win_sanity_this_pc
  win_sanity_password_policy
  win_sanity_services
}
