Unicode true
RequestExecutionLevel user

; Digi brand: charcoal, soft white, and muted gold.
; MUI2 gives the installer a consistent Windows wizard flow.
!include "MUI2.nsh"

!define APP_NAME "Digi"
!define APP_VERSION "1.1.0.0"
!define APP_EXE "Digi Search Engine.exe"
!define UPDATER_EXE "DigiUpdater.exe"
!define INSTALL_DIR "$LOCALAPPDATA\Digi"
!define START_MENU_DIR "$SMPROGRAMS\Digi"
!define BRAND_GOLD "D4AF37"
!define BRAND_DARK "202124"
!define BRAND_TEXT "E8E8E8"

Name "${APP_NAME}"
OutFile "DigiInstaller.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKCU "Software\Digi" "InstallDir"

VIProductVersion "${APP_VERSION}"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "${APP_VERSION}"
VIAddVersionKey "FileDescription" "Digi per-user installer"
VIAddVersionKey "CompanyName" "Digi"

; Branded welcome and finish pages.
!define MUI_WELCOMEPAGE_TITLE "Welcome to Digi"
!define MUI_WELCOMEPAGE_TEXT "Digi brings your workspace together. This setup will install Digi for your Windows user account.$\r$\n$\r$\nYour files and existing Search Repository will be preserved."
!define MUI_FINISHPAGE_TITLE "Digi is ready"
!define MUI_FINISHPAGE_TEXT "Digi has been installed. Select Finish to close setup."
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch Digi now"
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

; MUI's welcome/finish pages use the charcoal background and light text.
!define MUI_BGCOLOR "${BRAND_DARK}"
!define MUI_TEXTCOLOR "${BRAND_TEXT}"
!define MUI_WELCOMEFINISHPAGE_BITMAP_STRETCH

; Installer pages.
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages.
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

BrandingText "Digi  |  A calmer workspace"

ShowInstDetails show
ShowUninstDetails show

Function .onInit
  SetShellVarContext current
FunctionEnd

Section "Install Digi" SEC_INSTALL
  SetShellVarContext current
  SetOutPath "$INSTDIR"

  ; Payload files are built by Digi.app before this script is compiled.
  ; A missing payload file should make compilation fail rather than package a partial app.
  SetOverwrite on
  File "payload\Digi Search Engine.exe"
  File "payload\DigiUpdater.exe"
  File "payload\version.txt"

  ; Create app data folders only when missing; never clear existing content.
  CreateDirectory "$INSTDIR\Search Repository"
  CreateDirectory "$INSTDIR\Search Repository\Digi Notes"
  CreateDirectory "$INSTDIR\Cache"
  CreateDirectory "$INSTDIR\Logs"

  ; Digi initializes Version manager metadata on first launch.
  ; Do not create or overwrite that directory from the installer.

  WriteRegStr HKCU "Software\Digi" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "Software\Digi" "Version" "${APP_VERSION}"

  CreateDirectory "${START_MENU_DIR}"
  CreateShortcut "${START_MENU_DIR}\Digi.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0 SW_SHOWNORMAL "" "Launch Digi"
  CreateShortcut "${START_MENU_DIR}\Uninstall Digi.lnk" "$INSTDIR\Uninstall Digi.exe"

  CreateShortcut "$DESKTOP\Digi.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0 SW_SHOWNORMAL "" "Launch Digi"

  WriteUninstaller "$INSTDIR\Uninstall Digi.exe"
SectionEnd

Section "Uninstall"
  SetShellVarContext current

  Delete "$DESKTOP\Digi.lnk"
  Delete "${START_MENU_DIR}\Digi.lnk"
  Delete "${START_MENU_DIR}\Uninstall Digi.lnk"
  RMDir "${START_MENU_DIR}"

  ; Remove only app-owned files. Keep Search Repository, Cache, Logs,
  ; Version manager, and other user data.
  Delete "$INSTDIR\${APP_EXE}"
  Delete "$INSTDIR\${UPDATER_EXE}"
  Delete "$INSTDIR\version.txt"
  Delete "$INSTDIR\Uninstall Digi.exe"

  DeleteRegKey HKCU "Software\Digi"

  ; The directory remains if user data or unknown files still exist.
  RMDir "$INSTDIR"
SectionEnd
