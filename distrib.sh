#!/bin/sh

GAMENAME=baconthulhu
PACKAGENAME=baconthulhu

# Config used only for the Windows installer
LONGNAME="Bob the Hamster in the Crypt of Baconthulhu"
GAMEURL="http://rpg.hamsterrepublic.com/ohrrpgce/Game:Bob_the_Hamster_in_the_Crypt_of_Baconthulhu"
PUBLISHERNAME="Hamster Republic Productions"
PUBLISHERSHORTNAME="Hamster Republic"
PUBLISHERURL="http://HamsterRepublic.com/ohrrpgce/"

#######################################################################

RELUMP=~/src/ohr/wip/relump

rm -Rf distrib
mkdir distrib
cd distrib

wget http://hamsterrepublic.com/ohrrpgce/nightly/ohrrpgce-wip-default.zip
unzip ohrrpgce-wip-default.zip game.exe *.dll svninfo.txt
rm ohrrpgce-wip-default.zip

SVN=`grep "^Last Changed Rev:" svninfo.txt | cut -d " " -f 4`
DATE=`grep "^Last Changed Date:" svninfo.txt | cut -d " " -f 4 | tr "-" "."`

mv game.exe "${GAMENAME}".exe
"${RELUMP}" ../"${GAMENAME}".rpgdir ./"${GAMENAME}".rpg
cp ../LICENSE.txt .
cp ../README.txt .
cp ../"${GAMENAME}".hss .
cp ../"${GAMENAME}".ico .

# Create the zip file
rm ../"${PACKAGENAME}".zip
zip ../"${PACKAGENAME}".zip "${GAMENAME}".exe "${GAMENAME}".rpg LICENSE.txt README.txt *.dll "${GAMENAME}".hss

# Create the Windows installer
cat << EOF > "${GAMENAME}".iss
[Setup]
AppName=${LONGNAME}
AppVerName=${LONGNAME} ${DATE}.${SVN}
VersionInfoVersion=${DATE}.${SVN}
AppPublisher=${PUBLISHERNAME}
AppPublisherURL=${PUBLISHERURL}
AppSupportURL=${GAMEURL}
AppUpdatesURL=${GAMEURL}
AppReadmeFile={app}\README.txt
DefaultDirName={pf}\\${PUBLISHERSHORTNAME}\\${LONGNAME}
DefaultGroupName=${LONGNAME}
DisableProgramGroupPage=yes
AllowNoIcons=yes
AllowUNCPath=no
LicenseFile=LICENSE.txt
InfoAfterFile=README.txt
OutputBaseFilename=${PACKAGENAME}
Compression=bzip
SolidCompression=yes
ChangesAssociations=no
UninstallDisplayIcon={app}\\${GAMENAME}.ico

[Languages]
Name: "eng"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"

[Files]
Source: "${GAMENAME}.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "SDL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "SDL_mixer.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${GAMENAME}.rpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "${GAMENAME}.hss"; DestDir: "{app}"; Flags: ignoreversion
Source: "${GAMENAME}.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE.txt"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Dont use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\\${LONGNAME}"; Filename: "{app}\\${GAMENAME}.exe"; Flags: closeonexit
Name: "{group}\\${LONGNAME} (fullscreen)"; Filename: "{app}\\${GAMENAME}.exe"; Parameters: "-f"; Flags: closeonexit
Name: "{userdesktop}\\${LONGNAME}"; Filename: "{app}\\${GAMENAME}.exe"; Flags: closeonexit; Tasks: desktopicon
EOF

wine "C:\Program Files\Inno Setup 5\iscc" "${GAMENAME}".iss
mv Output/"${PACKAGENAME}".exe ../
rmdir Output
