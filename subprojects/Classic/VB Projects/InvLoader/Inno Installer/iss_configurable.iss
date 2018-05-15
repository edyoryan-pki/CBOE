; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
; this is same as default, except can choose whether or not to install vb6 and mdac

[Setup]
AppName=InvLoader
AppVerName=InvLoader 17.1.1
AppPublisher=PerkinElmer Corporation
AppPublisherURL=http://www.perkinelmer.com
AppSupportURL=http://www.perkinelmer.com
AppUpdatesURL=http://www.perkinelmer.com
DefaultDirName={pf}\PerkinElmer\InvLoader
DefaultGroupName=InvLoader
OutputBaseFilename=InvLoaderSetup
VersionInfoVersion=17.1.1
[Tasks]
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:

[Dirs]
Name: {app}\Logs

[Files]
Source: ..\Installer\Vsflex7.ocx; DestDir: {sys}; Flags: regserver sharedfile
Source: ..\Installer\ActiveWizard.ocx; DestDir: {sys}; Flags: regserver sharedfile
Source: ..\Installer\ComDLG32.ocx; DestDir: {sys}; Flags: restartreplace sharedfile regserver
Source: ..\Installer\MSComCtl.ocx; DestDir: {sys}; Flags: restartreplace sharedfile regserver
Source: ..\Installer\base64.dll; DestDir: {app}
Source: ..\Installer\base64Decode.dll; DestDir: {app}; Flags: regserver sharedfile
Source: ..\Installer\RegCodeCOM11.dll; Destdir: {app}; Flags: regserver sharedfile
Source: ..\Installer\MolServer11.dll; Destdir: {app}; Flags: regserver sharedfile
Source: ..\Installer\MolServer14.dll; Destdir: {app}; Flags: regserver sharedfile
Source: ..\Installer\MolServer15.dll; Destdir: {app}; Flags: regserver sharedfile
Source: ..\Installer\MolServer17.dll; Destdir: {app}; Flags: regserver sharedfile
Source: ..\Installer\InvLoader.exe; DestDir: {app}; Flags: ignoreversion
Source: ..\Installer\invloader.pdf; DestDir: {app}
Source: ..\Installer\reg_fields.xls; DestDir: {app}
Source: ..\Installer\msxml.msi; DestDir: {app}

[Run]
Filename: "{sys}\msiexec.exe"; Parameters: "/i ""{app}\msxml.msi"" /qb"; 


[Icons]
Name: {userdesktop}\Inventory Loader; Filename: {app}\InvLoader.exe; Tasks: desktopicon