Unicode true
RequestExecutionLevel user

!define APP_NAME "Digi"
!define APP_VERSION "1.1.0.0"
!define APP_EXE "Digi Search Engine.exe"
!define UPDATER_EXE "DigiUpdater.exe"
!define INSTALL_DIR "$LOCALAPPDATA\Digi"
!define START_MENU_DIR "$SMPROGRAMS\Digi"

Name "${APP_NAME}"
OutFile "DigiInstaller.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKCU "Software\Digi" "InstallDir"

VIProductVersion "${APP_VERSION}"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "${APP_VERSION}"
VIAddVersionKey "FileDescription" "Digi per-user installer"

ShowInstDetails show
ShowUninstDetails show

Section "Install Digi" SEC_INSTALL
  SetShellVarContext current
  SetOutPath "$INSTDIR"

  ; The EXEs are built before NSIS runs. Keep them in the installer\payload folder.
  SetOverwrite on
  File "payload\Digi Search Engine.exe"
  File "payload\DigiUpdater.exe"
  File "payload\version.txt"

  ; Create application data directories without deleting existing user data.
  CreateDirectory "$INSTDIR\Search Repository"
  CreateDirectory "$INSTDIR\Search Repository\Digi Notes"
  CreateDirectory "$INSTDIR\Cache"
  CreateDirectory "$INSTDIR\Logs"

  ; The app creates/validates Version manager metadata on first launch.
  ; Do not create or overwrite that directory here.

  WriteRegStr HKCU "Software\Digi" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "Software\Digi" "Version" "${APP_VERSION}"

  CreateDirectory "${START_MENU_DIR}"
  CreateShortcut "${START_MENU_DIR}\Digi.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0 SW_SHOWNORMAL "" "Launch Digi"
  CreateShortcut "${START_MENU_DIR}\Uninstall Digi.lnk" "$INSTDIR\Uninstall Digi.exe"

  ; Create a desktop shortcut for the current Windows user.
  CreateShortcut "$DESKTOP\Digi.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0 SW_SHOWNORMAL "" "Launch Digi"

  WriteUninstaller "$INSTDIR\Uninstall Digi.exe"
SectionEnd

Section "Uninstall"
  SetShellVarContext current

  Delete "$DESKTOP\Digi.lnk"
  Delete "${START_MENU_DIR}\Digi.lnk"
  Delete "${START_MENU_DIR}\Uninstall Digi.lnk"
  RMDir "${START_MENU_DIR}"

  ; Remove only application-owned files. Preserve Search Repository, Cache,
  ; Logs, Version manager, and any other user data in %LOCALAPPDATA%\Digi.
  Delete "$INSTDIR\${APP_EXE}"
  Delete "$INSTDIR\${UPDATER_EXE}"
  Delete "$INSTDIR\version.txt"
  Delete "$INSTDIR\Uninstall Digi.exe"

  DeleteRegKey HKCU "Software\Digi"

  ; This succeeds only if the install directory is empty; user data prevents
  ; it from being removed, which is intentional.
  RMDir "$INSTDIR"
SectionEnd
