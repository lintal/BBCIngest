; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "BBCIngest"
#define MyAppVersion GetStringFileInfo(".\bin\Release\BBCIngest.exe", "ProductVersion")
#define MyAppPublisher "BBC World Service"
#define MyAppURL "http://www.bbc.com/worldserviceradio"
#define MyAppExeName "BBCIngest.exe"
#define Settings "
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{C6FD1B2B-7DE0-415B-9645-62142D74CBC2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes 
OutputBaseFilename={#MyAppName}_{#MyAppVersion}
Compression=lzma
SolidCompression=yes
LicenseFile=licence.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: ".\bin\Release\{#MyAppName}.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\{#MyAppName}.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\{#MyAppName}.pdb"; DestDir: "{app}"; Flags: ignoreversion
;Source: ".\bin\Release\{#MyAppName}.vshost.exe"; DestDir: "{app}"; Flags: ignoreversion
;Source: ".\bin\Release\{#MyAppName}.vshost.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\Ingest.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\Ingest.pdb"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\Microsoft.Win32.TaskScheduler.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\Microsoft.Win32.TaskScheduler.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\bin\Release\taglib-sharp.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\logfileurl.txt"; DestDir: "{app}"; Flags: ignoreversion

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait skipifsilent; Parameters: "install"
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent; BeforeInstall: DeletePropertiesFile

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "uninstall";

[Code]
var
  UserPage  : TWizardPage;
  PostLogs  : TNewCheckBox;
  City      : TNewEdit;
  Station   : TNewEdit;

procedure ButtonOnClick(Sender: TObject);
begin
  MsgBox('You clicked the button!', mbInformation, mb_Ok);
end;

procedure InitializeWizard();
var
    flabel : TNewStaticText;
    y : Integer;
begin
  UserPage := CreateCustomPage(wpWelcome, 'Remote Logging', 'Please enter your Station and City');

  y := 8;

  flabel := TNewStaticText.Create(UserPage);
  flabel.Top := ScaleY(y+4)
  flabel.Caption := 'Because the program is licenc:';
  flabel.Parent := UserPage.Surface;

  flabel := TNewStaticText.Create(UserPage);
  flabel.Top := ScaleY(y+4)
  flabel.Caption := 'Station:';
  flabel.Parent := UserPage.Surface;

  Station := TNewEdit.Create(UserPage);
  Station.Top := ScaleY(y);
  Station.Left := ScaleX(48);
  Station.Width := UserPage.SurfaceWidth div 2 - ScaleX(8);
  Station.Text := 'Station';
  Station.Parent := UserPage.Surface;

  y := y + 56;

  flabel := TNewStaticText.Create(UserPage);
  flabel.Top := ScaleY(y+4)
  flabel.Caption := 'City:';
  flabel.Parent := UserPage.Surface;

  City := TNewEdit.Create(UserPage);
  City.Top := ScaleY(y);
  City.Left := ScaleX(48);
  City.Width := UserPage.SurfaceWidth div 2 - ScaleX(8);
  City.Text := 'City';
  City.Parent := UserPage.Surface;
      
  y := y + 56;

  PostLogs := TNewCheckBox.Create(UserPage);
  PostLogs.Top := ScaleY(y+4);
  PostLogs.Width := UserPage.SurfaceWidth div 2;
  PostLogs.Height := ScaleY(17);
  PostLogs.Caption := 'Allow Logs to be sent to the BBC';
  PostLogs.Checked := True;
  PostLogs.Parent := UserPage.Surface;

end;

procedure CurStepChanged(CurStep: TSetupStep);
var
 params     : TArrayOfString;
 url        : AnsiString;
 resultCode : Integer;
begin
    if  CurStep=ssPostInstall then
    begin
        SetLength(params, 4);
        params[0] := 'postLogs=';
        if PostLogs.Checked then begin
            params[0] := params[0] + '1';
        end
        else begin
            params[0] := params[0] + '0';
        end;
        params[1] := 'station=' + Station.Text;
        params[2] := 'city=' + City.Text;
        LoadStringFromFile(ExpandConstant('{app}/logfileurl.txt'), url);
        params[3] := 'logUrl='+url;
        SaveStringsToUTF8File(ExpandConstant('{app}/init.properties'), params, false);
   end;
end;

procedure DeletePropertiesFile();
begin
  DeleteFile(ExpandConstant('{app}/init.properties'));
  ;MsgBox('Deleted Properties File.', mbInformation, MB_OK);
end;

end.
