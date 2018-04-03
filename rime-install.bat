@echo off

setlocal

rem check for updates at https://github.com/git-for-windows/git/releases/latest
set git_version=2.16.3
set git_release=.1

if defined ProgramFiles(x86) (set arch=64) else (set arch=32)

set git_installer=Git-%git_version%%git_release:.1=%-%arch%-bit.exe

if "%git_mirror%" == "taobao" (
  set git_download_url_prefix=https://npm.taobao.org/mirrors/git-for-windows/
) else (
  set git_download_url_prefix=https://github.com/git-for-windows/git/releases/download/
)

set git_download_url=%git_download_url_prefix%v%git_version%.windows%git_release%/%git_installer%

where /q bash
if %errorlevel% equ 0 goto :bash_found

if exist %git_installer% (
   echo Found installer: %git_installer%
   rem TODO: verify installer
   goto :install_git
)

where /q curl
if %errorlevel% equ 0 (
   set downloader=curl -fsSL
   set save_to=-o
   goto :download_git
)

where /q powershell
if %errorlevel% equ 0 (
   set downloader=powershell Invoke-WebRequest
   set save_to=-OutFile
   goto :download_git
)

echo Error: neither curl nor powershell is found.
echo Please manually download and install git, then re-run %~n0:
echo %git_download_url%
exit /b 1

:download_git
echo Downloading installer: %git_installer%
%downloader% %git_download_url% %save_to% %git_installer%
if not exist %git_installer% (
echo Error downloading %git_installer%
exit /b 1
)
echo Download complete: %git_installer%

:install_git
echo Installing git ...
%git_installer% /GitAndUnixToolsOnPath

:bash_found

set PATH=%ProgramFiles%\Git\cmd;%ProgramFiles%\Git\mingw%arch%\bin;%ProgramFiles%\Git\usr\bin;%PATH%
rem path

if not defined plum_dir (
   set plum_dir=plum
)

if exist "%plum_dir%"/rime-install (
   bash "%plum_dir%"/rime-install %*
) else (
  echo Downloading rime-install ...
  curl -fsSL https://git.io/rime-install | bash -s -- %*
)