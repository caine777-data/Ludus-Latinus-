; ============================================================================
;  PythonLearn — script d'installation Windows (Inno Setup 6)
;  Emballe l'exécutable produit par PyInstaller dans un installateur .exe.
;
;  Prérequis : avoir généré dist\PythonLearn.exe (voir DIFFUSION.md), puis :
;     iscc packaging\installer.iss
;     iscc /DMaVersion=1.2.3 packaging\installer.iss     (version imposée)
;
;  Le résultat est déposé dans : Output\PythonLearn-Setup-<version>.exe
; ============================================================================

; La version peut être imposée en ligne de commande (c'est ce que fait la CI,
; à partir du tag Git). Sans cela, on retombe sur la valeur ci-dessous, qui
; doit rester alignée sur app/version.py.
#ifndef MaVersion
  #define MaVersion "1.0.1"
#endif

#define MonApp "LudusLatinus"
#define MonAuteur "Cédric Monna"
#define MonExe "LudusLatinus.exe"
#define MonSite "https://github.com/caine777-data/ludus-latinus"

[Setup]
; Identifiant stable de l'application : c'est lui qui permet à Windows de
; reconnaître une mise à jour plutôt que d'installer un second exemplaire.
; Ne JAMAIS le modifier une fois une version publiée.
AppId={{7F3A9C21-5D48-4E6B-9A17-2C8E4B0D6F35}
AppName={#MonApp}
AppVersion={#MaVersion}
AppVerName={#MonApp} {#MaVersion}
AppPublisher={#MonAuteur}
AppPublisherURL={#MonSite}
AppSupportURL={#MonSite}/issues
AppUpdatesURL={#MonSite}/releases
VersionInfoVersion={#MaVersion}
DefaultDirName={autopf}\{#MonApp}
DefaultGroupName={#MonApp}
DisableProgramGroupPage=yes
OutputDir=..\Output
OutputBaseFilename={#MonApp}-Setup-{#MaVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; Installe pour l'utilisateur courant : pas besoin de droits administrateur.
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64compatible
SetupIconFile=..\assets\icon.ico
UninstallDisplayIcon={app}\{#MonExe}
UninstallDisplayName={#MonApp} {#MaVersion}

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\dist\{#MonExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion
; Si PyInstaller produit un dossier (--onedir), utiliser plutôt :
; Source: "..\dist\{#MonApp}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MonApp}"; Filename: "{app}\{#MonExe}"
Name: "{group}\Désinstaller {#MonApp}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MonApp}"; Filename: "{app}\{#MonExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MonExe}"; Description: "{cm:LaunchProgram,{#MonApp}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; La progression de l'apprenant vit dans %USERPROFILE%\.python-learn et n'est
; volontairement PAS supprimée : désinstaller ne doit pas effacer son travail.
