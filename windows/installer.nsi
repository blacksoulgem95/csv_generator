; The name of the installer
Name "CSV Generator"

; To change from default installer icon:
;Icon "CSVGenerator.ico"

; The setup filename
OutFile "CSVGenerator_Setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\CSVGenerator

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\CSVGenerator" "Install_Dir"

RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "CSV Generator (required)"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there (you can add more File lines too)
  File "CSVGenerator.exe"
  ; Wildcards are allowed:
  File *.dll
  ; To add a folder named MYFOLDER and all files in it recursively, use this EXACT syntax:
  File /r data\*.*
  ; See: https://nsis.sourceforge.io/Reference/File
  ; MAKE SURE YOU PUT ALL THE FILES HERE IN THE UNINSTALLER TOO

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\CSVGenerator "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CSVGenerator" "DisplayName" "CSV Generator"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CSVGenerator" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CSVGenerator" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CSVGenerator" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts (required)"
  SectionIn RO

  CreateDirectory "$SMPROGRAMS\CSVGenerator"
  CreateShortcut "$SMPROGRAMS\CSVGenerator\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\CSVGenerator\CSV Generator.lnk" "$INSTDIR\CSVGenerator.exe" "" "$INSTDIR\CSVGenerator.exe" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CSVGenerator"
  DeleteRegKey HKLM SOFTWARE\CSVGenerator

  ; Remove files and uninstaller
  ; MAKE SURE NOT TO USE A WILDCARD. IF A
  ; USER CHOOSES A STUPID INSTALL DIRECTORY,
  ; YOU'LL WIPE OUT OTHER FILES TOO
  Delete $INSTDIR\CSVGenerator.exe
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\CSVGenerator\*.*"

  ; Remove directories used (only deletes empty dirs)
  RMDir "$SMPROGRAMS\CSVGenerator"
  RMDir "$INSTDIR"

SectionEnd