Unicode true
RequestExecutionLevel user

; Digi brand: charcoal, soft white, and muted gold.
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
OutFile "${__FILEDIR__}\DigiInstaller.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKCU "Software\Digi" "InstallDir"

VIProductVersion "${APP_VERSION}"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "${APP_VERSION}"
VIAddVersionKey "FileDescription" "Digi per-user installer"
VIAddVersionKey "CompanyName" "Digi"

; Branded welcome and finish pages.
!define MUI_WELCOMEPAGE_TITLE "Welcome to Digi"
!define MUI_WELCOMEPAGE_TEXT "Digi brings your workspace together. This setup will install Digi for your Windows user account.$\r$\n$\r$\nIf Digi is already installed, setup will ask before replacing the application executables. Your notes and other user data will be preserved."
!define MUI_FINISHPAGE_TITLE "Digi is ready"
!define MUI_FINISHPAGE_TEXT "Digi has been installed. Select Finish to close setup."
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch Digi now"
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

; MUI's welcome/finish pages use the charcoal background and light text.
!define MUI_BGCOLOR "${BRAND_DARK}"
!define MUI_TEXTCOLOR "${BRAND_TEXT}"

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
InstallColors "${BRAND_GOLD}" "${BRAND_DARK}"

ShowInstDetails show
ShowUninstDetails show

Function .onInit
  SetShellVarContext current

  ; Detect an existing install by its app executable or installer registry entry.
  ; Confirm before replacing app binaries; never delete the install directory.
  IfFileExists "$LOCALAPPDATA\Digi\${APP_EXE}" existing_digi_check
  ReadRegStr $0 HKCU "Software\Digi" "InstallDir"
  StrCmp $0 "" init_done
  IfFileExists "$0\${APP_EXE}" existing_digi_check init_done

  existing_digi_check:
    MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "Digi already exists on this computer.$\r$\n$\r$\nYes: replace the Digi application executables with this version.$\r$\nNo: cancel setup.$\r$\n$\r$\nYour Search Repository, notes, Cache, Logs, and Version manager data will not be intentionally deleted." IDYES init_done
    Abort

  init_done:
FunctionEnd

Section "Install Digi" SEC_INSTALL
  SetShellVarContext current
  SetOutPath "$INSTDIR"

  ; These are the two application binaries present in the supplied build output.
  ; Paths are relative to this .nsi file, so MakeNSISW can be opened from any directory.
  ; A missing payload file makes compilation fail instead of packaging a partial app.
  SetOverwrite on
  File "${__FILEDIR__}\payload\Digi Search Engine.exe"
  File "${__FILEDIR__}\payload\DigiUpdater.exe"

  ; Match the supplied post-build layout. Create folders only when missing;
  ; never clear existing content. The app bootstraps Version manager metadata.
  CreateDirectory "$INSTDIR\Search Repository"
  CreateDirectory "$INSTDIR\Search Repository\Digi Notes"
  CreateDirectory "$INSTDIR\Cache"
  CreateDirectory "$INSTDIR\Logs"

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

  ; Remove only app-owned files. Preserve user data and unknown files.
  Delete "$INSTDIR\${APP_EXE}"
  Delete "$INSTDIR\${UPDATER_EXE}"
  Delete "$INSTDIR\Uninstall Digi.exe"

  DeleteRegKey HKCU "Software\Digi"

  ; The directory remains if user data or unknown files still exist.
  RMDir "$INSTDIR"
SectionEnd
