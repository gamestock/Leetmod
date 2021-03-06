;NSIS Modern User Interface
;Multilingual Example Script
;Written by Joost Verburg

!define APPNAME "Leetmod"
!define APPVERSION "1.9"
!define MODFOLDER "leetmod"
; # Change for release
!define MODVERSION "19"
!define COD4TITLE "Call of Duty 4"
!define COD4TITLEREG "Call of Duty(R) 4"
!define COD4TITLEREGFULL "${COD4TITLEREG} - Modern Warfare(TM)"
!define LMSLOGAN "Patch ${APPVERSION} in mod"
!define APPREGNAME "COD4-${APPNAME}"


!define MUI_FINISHPAGE_RUN "$INSTDIR\iw3mp.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS "+set fs_game mods/${MODFOLDER}${MODVERSION} +exec leetmod.cfg"
!define MUI_FINISHPAGE_SHOWREADME "http://www.lnp.comyr.com/?q=newmaps"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Open Leetmod's website to download the new maps"
!define MUI_FINISHPAGE_LINK "Visit Leetmod's website and see all the new features"
#!define MUI_FINISHPAGE_LINK "Go to Leetmod's website to download the new maps"
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.leetmod.pt.am"

Var /GLOBAL LMINSTVER
Var /GLOBAL LMMODVER
Var /GLOBAL UPDATECONFIGS

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;Include String Functions

  !include "StrFunc.nsh"
	${StrRep}

;Include Custom Functions

  !include "otherFuncs.nsh"

;--------------------------------
;General

  ;Name and file
  Name "${APPNAME}"
  OutFile "${APPNAME}-${APPVERSION}.exe"
  
  ;Default installation folder
  InstallDirRegKey HKLM "SOFTWARE\Activision\Call of Duty 4" InstallPath

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${APPREGNAME}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "LICENSE"
  !define MUI_PAGE_CUSTOMFUNCTION_PRE DirectoryPre
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  ;!insertmacro MUI_UNPAGE_CONFIRM
  ;!insertmacro MUI_UNPAGE_INSTFILES
  ;!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections

Section "${APPNAME}" Leetmod
  SectionIn RO
  
  Var /GLOBAL SMGAMEFOLDER
  Var /GLOBAL SHORTCUTTOMOD
  
  ;ADD YOUR OWN FILES HERE...
  
  SetOutPath "$INSTDIR\mods\${MODFOLDER}${MODVERSION}"
  File ".\..\mod.ff"
  File ".\..\leetmod${MODVERSION}.iwd"
  File ".\..\leetmod.cfg"
	SetOutPath "$INSTDIR\mods\${MODFOLDER}${MODVERSION}\configs"
	File /r ".\..\configs\*.*"
	SetOutPath "$INSTDIR\mods\${MODFOLDER}${MODVERSION}\pb"
	File /r ".\..\pb\*.*"
	
	; Update configs
	StrCmp $UPDATECONFIGS "1" 0 EndUpdateConfigs
		CopyFiles /SILENT "$INSTDIR\mods\${MODFOLDER}$LMMODVER\configs\*.*" "$INSTDIR\mods\${MODFOLDER}${MODVERSION}\configs\"
		StrCmp $LMINSTVER "1.8" 0 UpdateFrom19
			!include "update_configs_1.8-1.9.nsh"
		UpdateFrom19:
		;StrCmp $LMINSTVER "1.9" 0 UpdateFrom20
			;!include "update_configs_1.9-2.0.nsh"
		;UpdateFrom20:
	
	EndUpdateConfigs:
  ; Create Shortcuts
  SetShellVarContext all
  SetOutPath "$INSTDIR"
  ReadRegStr $SMGAMEFOLDER HKLM "SOFTWARE\Activision\Call of Duty 4" StartMenuFolder
  StrCmp $SMGAMEFOLDER "" 0 ExistsStartMenu
    StrCpy $SMGAMEFOLDER "$SMPROGRAMS\Activision\${COD4TITLEREGFULL}"
    createDirectory "$SMGAMEFOLDER"
  ExistsStartMenu:
  createShortCut "$SMGAMEFOLDER\${COD4TITLEREG} - ${APPNAME}.lnk" "$INSTDIR\iw3mp.exe" \
    "+set fs_game mods/${MODFOLDER}${MODVERSION} +exec leetmod.cfg" "" "" "" "ALT|CONTROL|SHIFT|L" "${LMSLOGAN}"
  createShortCut "$DESKTOP\${COD4TITLEREG} - ${APPNAME}.lnk" "$INSTDIR\iw3mp.exe" \
    "+set fs_game mods/${MODFOLDER}${MODVERSION} +exec leetmod.cfg" "" "" "" "ALT|CONTROL|SHIFT|L" "${LMSLOGAN}"
  StrCpy $SHORTCUTTOMOD "$SMGAMEFOLDER\${COD4TITLEREG} - ${APPNAME}.lnk"
  
  ;Store installation folder
  WriteRegStr HKLM "Software\${APPREGNAME}" "" $INSTDIR
  WriteRegStr HKLM "Software\${APPREGNAME}" "Version" ${APPVERSION}

SectionEnd
; #This were disabled since we don't pack maps in the installer
/*
SubSection "New Maps" MapPack
  Section "Carentan (CoD2)" CoD2Carentan
    SetOutPath "$INSTDIR\usermaps\mp_ctan\"
    File /r ".\..\..\..\usermaps\mp_ctan\"
  SectionEnd
  Section "Favela (MW2)" MW2Favela
    SetOutPath "$INSTDIR\usermaps\mp_fav\"
    File /r ".\..\..\..\usermaps\mp_fav\"
  SectionEnd
  Section "Highrise (MW2)" MW2Highrise
    SetOutPath "$INSTDIR\usermaps\mp_highrise\"
    File /r ".\..\..\..\usermaps\mp_highrise\"
  SectionEnd
  Section "Invasion (MW2)" MW2Invasion
    SetOutPath "$INSTDIR\usermaps\mp_inv\"
    File /r ".\..\..\..\usermaps\mp_inv\"
  SectionEnd
  Section "Rust (MW2)" MW2Rust
    SetOutPath "$INSTDIR\usermaps\mp_modern_rust\"
    File /r ".\..\..\..\usermaps\mp_modern_rust\"
  SectionEnd
  Section "Scrapyard (MW2)" MW2Scrapyard
    SetOutPath "$INSTDIR\usermaps\mp_scrapyard\"
    File /r ".\..\..\..\usermaps\mp_scrapyard\"
  SectionEnd
  Section "Skidrow (MW2)" MW2Skidrow
    SetOutPath "$INSTDIR\usermaps\mp_skidrow\"
    File /r ".\..\..\..\usermaps\mp_skidrow\"
  SectionEnd
  Section "Terminal (MW2)" MW2Terminal
    SetOutPath "$INSTDIR\usermaps\mp_mw2_term\"
    File /r ".\..\..\..\usermaps\mp_mw2_term\"
  SectionEnd
  Section "Nuketown (BO)" BONuketown
    SetOutPath "$INSTDIR\usermaps\mp_ntown\"
    File /r ".\..\..\..\usermaps\mp_ntown\"
  SectionEnd
  Section "Summit (BO)" BOSummit
    SetOutPath "$INSTDIR\usermaps\mp_summit\"
    File /r ".\..\..\..\usermaps\mp_summit\"
  SectionEnd
  Section "Garena" CTGarena
    SetOutPath "$INSTDIR\usermaps\mp_garena\"
    File /r ".\..\..\..\usermaps\mp_garena\"
  SectionEnd
  Section "Hangar" CTHangar
    SetOutPath "$INSTDIR\usermaps\mp_sc_hangar\"
    File /r ".\..\..\..\usermaps\mp_sc_hangar\"
  SectionEnd
  Section "Shipment 2" CTShipment2
    SetOutPath "$INSTDIR\usermaps\mp_shipment2\"
    File /r ".\..\..\..\usermaps\mp_shipment2\"
  SectionEnd
  Section "Shipment 3" CTShipment3
    ;SetOutPath "$INSTDIR\usermaps\mp_shipmentX\"
    ;File /r ".\..\..\..\usermaps\mp_shipmentX\"
  SectionEnd
SubSectionEnd
*/

;--------------------------------
;Installer Functions

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onVerifyInstDir
  IfFileExists $INSTDIR\iw3mp.exe PathGood
    Abort ; if the game isn't installed, don't continue
  PathGood:
FunctionEnd

Function DirectoryPre
  Var /GLOBAL COD4PATCH

  ; read the COD4 patch version from the registry
  ReadRegStr $COD4PATCH HKLM "SOFTWARE\Activision\Call of Duty 4" Version
 
  ; Check for APP installation existence
  StrCmp $INSTDIR "" 0 CheckGameFile  ; If there's no installdir
    StrCpy $INSTDIR "$PROGRAMFILES\Activision\Call of Duty 4 - Modern Warfare\"
    ; Check if game file exists
    CheckGameFile:
    IfFileExists "$INSTDIR\iw3mp.exe" 0 NoInstallationFound
      ; Check if game is patched
      StrCmp $COD4PATCH "1.7" NoAbortInst
        MessageBox MB_YESNO|MB_ICONQUESTION "You don't have ${COD4TITLE} patch 1.7 installed. \
          Do you want to continue anyway?" IDYES NoAbortInst
        Abort ; abort if game isn't patched
  NoInstallationFound:
  MessageBox MB_OK "${COD4TITLE} installation was not found. \
    Please point to where it is installed."
  NoAbortInst:
  
FunctionEnd

Function DirectoryLeave
	; read the Leetmod version from the registry
  ReadRegStr $LMINSTVER HKLM "Software\${APPREGNAME}" Version
  StrCmp $LMINSTVER "" 0 LMVersionProcessed	; If no version was found  (still, 1.8 could be installed)
    ReadRegStr $LMINSTVER HKLM "Software\${APPREGNAME}" ""		; If Leetmod 1.8 is installed, this is valid
		StrCmp $LMINSTVER "" NoConfigsFound
			StrCpy $LMINSTVER "1.8"
  LMVersionProcessed:
	; Remove the dot from version
	${StrRep} $LMMODVER $LMINSTVER "." ""
	; If it is a reinstallation, skip configs copy
	StrCmp $LMINSTVER ${APPVERSION} IsReinstallation
	; Check for Leetmod older version configs folder
	IfFileExists "$INSTDIR\mods\${MODFOLDER}$LMMODVER\configs\*.*" 0 NoConfigsFound
	  ; Ask if user wants to update existing configs or install new ones
		MessageBox MB_YESNO|MB_ICONQUESTION "Older Leetmod $LMINSTVER installation found. Do you want to copy over its 'configs' folder \
		  to this ${APPVERSION} installation? (They will also be updated with the new changes)" IDNO NoConfigsFound
			;Copy configs and update them
			StrCpy $UPDATECONFIGS "1"
			Goto EndProcessed
  
	IsReinstallation:
	; Ask if user wants to reinstall Leetmod
	MessageBox MB_YESNO|MB_ICONQUESTION "Leetmod $LMINSTVER is already installed. Do you want to reinstall it?" IDYES NoConfigsFound
		Quit
	
	NoConfigsFound:
	StrCpy $UPDATECONFIGS "0"
	Goto EndProcessed
	
	EndProcessed:
	
FunctionEnd

;--------------------------------
;Descriptions

  ;USE A LANGUAGE STRING IF YOU WANT YOUR DESCRIPTIONS TO BE LANGAUGE SPECIFIC

  	; #This were disabled since we don't pack maps in the installer
	;Assign descriptions to sections
	/*
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Leetmod} "${LMSLOGAN}"
    !insertmacro MUI_DESCRIPTION_TEXT ${MapPack} "New multiplayer maps made by talented community members"
    !insertmacro MUI_DESCRIPTION_TEXT ${CoD2Carentan} "Remake of a Call of Duty 2 map with the same name by Seven A.K.A. SevenSniff"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Favela} "Remake of a Modern Warfare 2 map with the same name by miregrobar"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Highrise} "Remake of a Modern Warfare 2 map with the same name by miregrobar"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Invasion} "Remake of a Modern Warfare 2 map with the same name by miregrobar"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Rust} "Remake of a Modern Warfare 2 map with the same name by Coverop"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Scrapyard} "Remake of a Modern Warfare 2 map with the same name by the SPS Team (PanzerMan and Dugynight)"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Skidrow} "Remake of a Modern Warfare 2 map with the same name by WarMachine"
    !insertmacro MUI_DESCRIPTION_TEXT ${MW2Terminal} "Remake of a Modern Warfare 2 map with the same name by K6Grimm and BU|D-ToX"
    !insertmacro MUI_DESCRIPTION_TEXT ${BONuketown} "Remake of a Black Ops map map with the same name by ColdAir"
    !insertmacro MUI_DESCRIPTION_TEXT ${BOSummit} "Remake of a Black Ops map with the same name by K6Grimm and BU|D-ToX"
    !insertmacro MUI_DESCRIPTION_TEXT ${CTGarena} "New map by |RASTA|RoKo_859"
    !insertmacro MUI_DESCRIPTION_TEXT ${CTHangar} "New map by miregrobar"
    !insertmacro MUI_DESCRIPTION_TEXT ${CTShipment2} "New map by Carcass26"
    !insertmacro MUI_DESCRIPTION_TEXT ${CTShipment3} "New map by LLLDR|dB99"
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
	*/