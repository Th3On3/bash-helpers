<h1 align="center">bash-helpers</h1>

This project offers cross-plataform (linux, macOS, windows) bash helpers to: configure OS Desktop Shell (e.g., dark mode, disable animations), install software (e.g., python, vscode, docker, others bashs) and utilities (e.g., git, npm, compress, pdf, vscode, curl).

# How to install bash-helpers

The bash-helpers has two requeriments: a `bash shell` and `git` . You may easy install using the scripts bellow.

MacOS already has a bash shell.  
Run in a bash shell the script [install/bh-on-mac.sh](install/bh-on-mac.sh) to install git and bash-helpers:

```bash
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/alanlivio/bash-helpers/master/install/bh-on-mac.sh)"
```

Ubuntu already has a bash.  
Run in a bash shell the script [install/bh-on-ubuntu.sh](install/bh-on-ubuntu.sh), to install git and bash-helpers:

```bash
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/alanlivio/bash-helpers/master/install/bh-on-ubuntu.sh)"
```

Windows do not has `bash shell` nor `git` .
Run in a powershell shell the script [install/bh-on-win.ps1](install/bh-on-win.ps1) to install git, GitBash, and bash-helpers:

```powershell
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/alanlivio/bash-helpers/master/install/bh-on-win.ps1'))
```

# helpers

### helpers for Desktop Shell sanity

* `bh_gnome_sanity` (at ubuntu bash): to configure Gnome Shell
* `bh_win_sanity` (at gitbash, run): to configure windows Shell

### helpers to install windows MSYS

* `bh_install_msys` (at windows GitBash): to install msys (Cygwin-based) with bash to build GNU-based win32 applications

### helpers to install windows WSL

* `bh_install_wsl` (at windows GitBash): to install WSL/Ubuntu (version 2, fixed home). This helper automate the process describred in [Microsoft WSL Tutorial](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install). After run, it requeres restart windows and run it again. When Ubuntu app started, you need configure your username/password.

### helpers for update/clean

The helpers bellow can be run routinely from differnt bashs. They install python/vscode if not installed. Then use variables defined in ~/.bashrc or ~/.bh-cfg.sh to configure/upgrade packges and cleanup unused files/folders. Please see the variables in the [skel/.bh-cfg.sh](skel/.bh-cfg.sh).

* `bh_update_clean_ubuntu` (at ubuntu bash)
* `bh_update_clean_mac` (at mac bash)
* `bh_update_clean_wsl` (at WSL bash)
* `bh_update_clean_win` (at GitBash)
* `bh_update_clean_msys` (at msys bash)

### helpers for home managment

* `bh_home_backup_save`: backup files/dirs defined in BH_HOME_BKPS
* `bh_home_backup_diff`: show diff files/dirs defined in BH_HOME_BKPS
* `bh_home_backup_restore`: restore files/dirs defined in BH_HOME_BKPS
* `bh_home_clean_unused`: clean files/dirs defined in array BH_HOME_CLEAN_UNUSED

### others helpers

The helpers bellow used for specifc commands. For the full list, see [libs folder](lib/).

* `bh_android_*`: android helpers. See full list at [lib/android.sh](lib/android.sh).
* `bh_cmake_*`: cmake helpers. See full list at [lib/cmake.sh](lib/cmake.sh).
* `bh_compress_*`: compress helpers. See full list at [lib/compress.sh](lib/compress.sh), etc.
* `bh_curl_*`: curl helpers. See full list at [lib/curl.sh](lib/curl.sh).
* `bh_cmake_*`: cmake helpers. See full list at [lib/cmake.sh](lib/cmake.sh).
* `bh_diff_*`: diff helpers. See full list at [lib/diff.sh](lib/diff.sh).
* `bh_docker_*`: docker helpers. See full list at [lib/docker.sh](lib/docker.sh).
* `bh_ffmpeg_*`: ffmpeg helpers. See full list at [lib/ffmpeg.sh](lib/ffmpeg.sh).
* `bh_flutter_*`: flutter helpers. See full list at [lib/flutter.sh](lib/flutter.sh).
* `bh_gcc_*`: gcc helpers. See full list at [lib/gcc.sh](lib/gcc.sh).
* `bh_git_*`: git helpers. See full list at [lib/git.sh](lib/git.sh).
* `bh_meson_*`: meson helpers. See full list at [lib/meson.sh](lib/meson.sh).
* `bh_mount_*`: mount helpers. See full list at [lib/mount.sh](lib/mount.sh).
* `bh_npm_*`: npm helpers. See full list at [lib/npm.sh](lib/mount.sh).
* `bh_pandoc_*`: pandoc helpers. See full list at [lib/pandoc.sh](lib/pandoc.sh).
* `bh_pdf_*`: pdf helpers. See full list at [lib/pdf.sh](lib/pdf.sh).
* `bh_python_*`: python helpers. See full list at [lib/python.sh](lib/python.sh).
* `bh_vscode_*`: vscode helpers. See full list at [lib/vscode.sh](lib/vscode.sh).
* `bh_wget_*`: wget helpers. See full list at [lib/wget.sh](lib/wget.sh).
* `bh_youtubedl_*`: youtube-dl helpers. See full list at [lib/youtubedl.sh](lib/youtubedl.sh).
* `bh_zip_*`: zip helpers. See full list at [lib/zip.sh](lib/zip.sh).  


# References

Other github projects were used as reference:

* https://github.com/wd5gnr/bashrc
* https://github.com/martinburger/bash-common-helpers
* https://github.com/jonathantneal/git-bash-helpers
* https://github.com/Bash-it/bash-it
* https://github.com/donnemartin/dev-setup
* https://github.com/aspiers/shell-env

And, particulary, references for helpers on windows:

* https://github.com/adolfintel/windows10-Privacy
* https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
* https://github.com/RanzigeButter/fyWin10/blob/master/fyWin10.ps1
* https://github.com/madbomb122/Win10Script/blob/master/Win10-Menu.ps1
* https://github.com/Sycnex/windows10Debloater/blob/master/windows10Debloater.ps1
* https://github.com/W4RH4WK/Debloat-windows-10/tree/master/scripts
