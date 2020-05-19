#define MyAppName "modharbour"
#define MyAppVersion "2.0"
#define MyAppPublisher "FiveTech Software (c) 2019,2020"
#define MyAppURL "http://www.modharbour.org"

[Setup]
; SignTool=signtool
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{B86542BD-ECFF-4834-B9D6-62771476D533}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\{#MyAppName}
DisableDirPage=no
DefaultGroupName={#MyAppName}
LicenseFile=..\..\..\LICENSE
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputBaseFilename=modharbour
SetupIconFile=..\..\..\docs\favicon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
WizardSizePercent=150

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Files]
Source: "..\..\..\windows\win64\mod_harbour.so"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\..\windows\win64\libharbour.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\..\IIS\bin\mod_harbour.dll"; DestDir: "{app}\IIS"; Flags: ignoreversion
Source: "..\..\..\samples\*"; DestDir: "{app}\samples"; Flags: ignoreversion recursesubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]
type
  TTimerProc = procedure( Wnd: HWND; Msg: UINT; TimerID: UINT_PTR; SysTime: DWORD );
  GpGraphics = Longword;
  GpImage = Longword;
  Status = (
    Ok,                       //  0
    GenericError,             //  1
    InvalidParameter,         //  2
    OutOfMemory,              //  3
    ObjectBusy,               //  4
    InsufficientBuffer,       //  5
    NotImplemented,           //  6
    Win32Error,               //  7
    WrongState,               //  8
    Aborted,                  //  9
    FileNotFound,             // 10
    ValueOverflow,            // 11
    AccessDenied,             // 12
    UnknownImageFormat,       // 13
    FontFamilyNotFound,       // 14
    FontStyleNotFound,        // 15
    NotTrueTypeFont,          // 16
    UnsupportedGdiplusVersion,// 17
    GdiplusNotInitialized,    // 18
    PropertyNotFound,         // 19
    PropertyNotSupported      // 20
  );
  GpStatus = Status;

  GdiplusStartupInput = record
   GdiplusVersion          : Cardinal; 
   DebugEventCallback      : Longword; 
   SuppressBackgroundThread: BOOL;     
   SuppressExternalCodecs  : BOOL;     
  end;                                 

  GdiplusStartupOutput = record
    NotificationHook  : Longword;
    NotificationUnhook: Longword;
  end;

var
  ServersPage: TInputQueryWizardPage;
  ApacheCheckBox, XamppCheckBox, IISCheckBox: TNewCheckBox;
  ApacheEdit, XamppEdit, IISEdit: TEdit;
  ApacheButton, XamppButton, IISButton: TButton;
  ApacheInstallButton, XamppInstallButton, IISInstallButton: TButton;
  ResultLabel: TLabel;
  cTmpFile1, cTmpFile2, Parameters: string;
  retCode: integer;
  cHtml: AnsiString;
  ClockImage: TPanel;
  TimerID: Integer;
  token: Longword;
  inputbuf: GdiplusStartupInput;
  outputbuf: GdiplusStartupOutput;
  graphics: GpGraphics;
  image: GpImage;
  status: GpStatus;
  count: Integer;
  dimensionID: array[ 0..1 ] of TGuid;
  iFrame: Integer;

procedure Assert( status: GpStatus );
begin
   if status <> Ok then
   begin
      MsgBox( intToStr( Integer( status ) ), mbInformation, 1 );
   end
end;

function Wide( str: AnsiString ):String;
var
  i : Integer;
  iChar : Integer;
  outString : String;
begin
  outString :='';
  for i := 1 to Length( str ) do
  begin
    outString := outString + Chr( Ord( str[ i ] ) ) + Chr( 0 );
  end;

  Result := outString;
end;

function SetTimer( hWnd, nIDEvent, uElapse, lpTimerFunc: Longword ): Longword;
external 'SetTimer@user32.dll stdcall';

function KillTimer( hWnd: HWND; uIDEvent: UINT ): BOOL; 
external 'KillTimer@user32.dll stdcall'; 

function GdiplusStartup( var token: Longword; var inputbuf: GdiPlusStartupInput; var outputbuf: GdiplusStartupOutput ): GpStatus;
external 'GdiplusStartup@GdiPlus.dll stdcall';

procedure GdiplusShutdown( token: Longword );
external 'GdiplusShutdown@GdiPlus.dll stdcall';

function GdipCreateFromHWND( hWnd: HWND; var graphics: GpGraphics ): GpStatus;
external 'GdipCreateFromHWND@GdiPlus.dll stdcall';

function GdipLoadImageFromFile( filename: string; var image: GpImage ): GpStatus;
external 'GdipLoadImageFromFile@GdiPlus.dll stdcall';

function GdipDrawImageRect( graphics: GpGraphics; image: GpImage; x,y: single; width, height: single ): GpStatus;
external 'GdipDrawImageRect@GdiPlus.dll stdcall';

function GdipImageGetFrameDimensionsCount( image: GpImage; var count: Integer ): GpStatus;
external 'GdipImageGetFrameDimensionsCount@GdiPlus.dll stdcall';

function GdipImageGetFrameCount( image: GpImage; var dimensionID: TGuid; var count: Integer ): GpStatus;
external 'GdipImageGetFrameCount@GdiPlus.dll stdcall';

function GdipImageGetFrameDimensionsList( image: GpImage; var dimensionID: TGuid; count: Integer ): GpStatus;
external 'GdipImageGetFrameDimensionsList@GdiPlus.dll stdcall';

function GdipImageSelectActiveFrame( image: GpImage; dimensionID: TGuid; frameIndex: Integer ): GpStatus;
external 'GdipImageSelectActiveFrame@GdiPlus.dll stdcall';

procedure MyTimerProc( Arg1, Arg2, Arg3, Arg4: Longword );
begin
  if iFrame < count then begin
    iFrame := iFrame + 1;
  end else begin
    iFrame := 0
  end;

  status := GdipImageSelectActiveFrame( image, dimensionID[ 0 ], iFrame );
  status := GdipDrawImageRect( graphics, image, 0, 0, ClockImage.Width, ClockImage.Height ); 
end;

procedure ApacheClick( sender: TObject );
begin
  ApacheEdit.enabled   := ( sender as TNewCheckBox ).checked;
  ApacheButton.enabled := ( sender as TNewCheckBox ).checked;
  ApacheInstallButton.enabled := ( sender as TNewCheckBox ).checked;
end;

procedure ApacheButtonClick( sender: TObject );
var
  ApachePath : string;
begin
  ApachePath := ApacheEdit.Text; 
  if BrowseForFolder( 'Select Apache path', ApachePath, true ) then
    ApacheEdit.Text := ApachePath;
end;

procedure ApacheInstallClick( sender: TObject );
begin
  ( sender as TButton ).Caption := 'wait...';
  ( sender as TButton ).Enabled := false;
  
  if DirExists( ApacheEdit.Text ) then
  begin
    if MsgBox( 'It seems as Apache is already installed, do you want to reinstall it ?', mbConfirmation, MB_YESNO ) = IDNO then
    begin
      ( sender as TButton ).Enabled := true;
      exit;
    end;
  end;       
   
  ResultLabel.Caption := 'Downloading, please wait...';

  TimerID := SetTimer( 0, 0, 25, CreateCallback( @MyTimerProc ) );
  ExtractTemporaryFile( 'sand-clock-dribbble.gif' );

  inputbuf.GdiplusVersion := 1;
  status := GdiplusStartup( token, inputbuf, outputbuf ); 
  // Assert( status );
  status := GdipCreateFromHWND( ClockImage.Handle, graphics ); 
  // Assert( status );
  status := GdipLoadImageFromFile( ExpandConstant( '{tmp}' ) + '\sand-clock-dribbble.gif', image );
  // Assert( status );
  // MsgBox( intToStr( image ), mbInformation, 1 );
  status := GdipDrawImageRect( graphics, image, 0, 0, ClockImage.Width, ClockImage.Height ); 
  // Assert( status );
  status := GdipImageGetFrameDimensionsCount( image, count );
  // Assert( status );
  // MsgBox( intToStr( count ), mbInformation, 1 );
  status := GdipImageGetFrameDimensionsList( image, dimensionID[ 0 ], count );
  // Assert( status );
  // MsgBox( intToStr( count ), mbInformation, 1 );
  status := GdipImageGetFrameCount( image, dimensionID[ 0 ], count );
  // Assert( status );
  // MsgBox( intToStr( count ), mbInformation, 1 );  
  iFrame := 1
  status := GdipImageSelectActiveFrame( image, dimensionID[ 0 ], iFrame );

  if IsWin64() then
  begin
   cTmpFile1  := ExpandConstant( '{tmp}\httpd-2.4.43-o111g-x64-vc15.zip' ); 
   Parameters := '(new-object System.Net.WebClient).DownloadFile( ''https://www.apachehaus.com/downloads/httpd-2.4.43-o111g-x64-vc15.zip'',''' + 
                 cTmpFile1 + ''')';    
  end else begin
   cTmpFile1  := ExpandConstant( '{tmp}\https://www.apachehaus.com/downloads/httpd-2.4.43-o111g-x86-vc15.zip' ); 
   Parameters := '(new-object System.Net.WebClient).DownloadFile( ''https://www.apachehaus.com/downloads/httpd-2.4.43-o111g-x86-vc15.zip'',''' + 
                 cTmpFile1 + ''')';    
  end;

  if Exec( 'powershell.exe', Parameters, '', SW_HIDE, ewWaitUntilTerminated, retCode ) and FileExists( cTmpFile1 ) then
  begin
   ResultLabel.Caption := 'Apache downloaded, proceeding to install it...';
   cTmpFile2 := ExpandConstant( '{tmp}\Apache24' );
   Parameters := 'Expand-Archive -LiteralPath ' + cTmpFile1 + ' -DestinationPath ' + cTmpFile2 + ' -Force';
   Exec( 'powershell.exe', Parameters, '', SW_HIDE, ewWaitUntilTerminated, retCode );
   Exec( 'powershell.exe', 'Copy-Item ' + cTmpFile2 + '\Apache24' + ' -Destination c:\ -recurse', '', SW_HIDE, ewWaitUntilTerminated, retCode ); 
   ResultLabel.Caption := 'done';
  end else begin
   ResultLabel.Caption := 'Can''t download Apache right now';
  end;

  // SysErrorMessage( retCode )
  KillTimer( 0, TimerID );
  ClockImage.Hide();
  GdiplusShutdown( token );

end;

procedure XamppButtonClick( sender: TObject );
var
  XamppPath: string;
begin
  XamppPath := XamppEdit.Text;
  if BrowseForFolder( 'Select Xampp path', XamppPath, true ) then
    XamppEdit.Text := XamppPath;
end;

procedure IISButtonClick( sender: TObject );
var
  IISPath: string;
begin
  IISPath := IISEdit.Text;
  if BrowseForFolder( 'Select IIS path', IISPath, true ) then
    IISEdit.Text := IISPath;
end;

procedure XamppClick( sender: TObject );
begin
  XamppEdit.enabled   := ( sender as TNewCheckBox ).checked;
  XamppButton.enabled := ( sender as TNewCheckBox ).checked;
  XamppInstallButton.enabled := ( sender as TNewCheckBox ).checked;
end;

procedure IISClick( sender: TObject );
begin
  IISEdit.enabled   := ( sender as TNewCheckBox ).checked;
  IISButton.enabled := ( sender as TNewCheckBox ).checked;
  IISInstallButton.enabled := ( sender as TNewCheckBox ).checked;
end;

procedure AddServersPage();
begin
  ServersPage := CreateInputQueryPage( wpWelcome, 'Please select the web server(s) to use',
                                       'This installer helps you to install the web server(s) if you have not installed them yet...', 
                                       'mod_harbour supports Apache, Xampp and Windows IIS');

  ApacheCheckBox := TNewCheckBox.Create( ServersPage );
  with ApacheCheckBox do
  begin
    Parent   := ServersPage.Surface;
    Top      := ApacheCheckBox.Top + 50; 
    Left     := ApacheCheckBox.Left + 20; 
    Caption  := 'Apache';
    OnClick  := @ApacheClick;
    TabOrder := 1;
  end;

  ApacheEdit := TEdit.Create( ServersPage );
  with ApacheEdit do
  begin
    Parent   := ServersPage.Surface;
    Top      := ApacheCheckBox.Top;
    Left     := ApacheCheckBox.Left + 100;
    Width    := 200; 
    Height   := ScaleY( 25 );
    Text     := 'c:\Apache24';
    Enabled  := ApacheCheckBox.checked;
    TabOrder := 2;
  end;

  ApacheButton := TButton.Create( ServersPage );
  with ApacheButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := ApacheEdit.Top - 2;
    Left     := ApacheEdit.Width + 140;
    Width    := 70;
    Height   := 25;
    Caption  := '&Browse...'
    OnClick  := @ApacheButtonClick;
    TabOrder := 3;
  end;

  ApacheInstallButton := TButton.Create( ServersPage );
  with ApacheInstallButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := ApacheEdit.Top - 2;
    Left     := ApacheButton.Left + ApacheButton.Width + 10;
    Width    := 80;
    Height   := 25;
    Caption  := '&Install...'
    OnClick  := @ApacheInstallClick;
    TabOrder := 4;
  end;

  XamppCheckBox := TNewCheckBox.Create( ServersPage );
  with XamppCheckBox do
  begin
    Parent   := ServersPage.Surface;
    Top      := ApacheCheckBox.Top + 40; 
    Left     := ApacheCheckBox.Left; 
    Caption  := 'Xampp';
    OnClick  := @XamppClick;
    TabOrder := 4;
  end;    

  XamppEdit := TEdit.Create( ServersPage );
  with XamppEdit do
  begin
    Parent   := ServersPage.Surface;
    Top      := XamppCheckBox.Top;
    Left     := ApacheCheckBox.Left + 100;
    Width    := 200; 
    Height   := ScaleY( 25 );
    TabOrder := 1;
    Text     := 'c:\xampp';
    Enabled  := XamppCheckBox.checked;
    TabOrder := 5;
  end;

  XamppButton := TButton.Create( ServersPage );
  with XamppButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := XamppEdit.Top - 2;
    Left     := XamppEdit.Width + 140;
    Width    := 70;
    Height   := 25;
    Caption  := '&Browse...'
    OnClick  := @XamppButtonClick;
    TabOrder := 6;
  end;

  XamppInstallButton := TButton.Create( ServersPage );
  with XamppInstallButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := XamppEdit.Top - 2;
    Left     := XamppButton.Left + XamppButton.Width + 10;
    Width    := 80;
    Height   := 25;
    Caption  := '&Install...'
    // OnClick  := @ApacheButtonClick;
    TabOrder := 4;
  end;

  IISCheckBox := TNewCheckBox.Create( ServersPage );
  with IISCheckBox do
  begin
    Parent   := ServersPage.Surface;
    Top      := XamppCheckBox.Top + 40; 
    Left     := ApacheCheckBox.Left; 
    Caption  := 'Microsoft IIS';
    OnClick  := @IISClick;
    TabOrder := 7;
  end;    

  IISEdit := TEdit.Create( ServersPage );
  with IISEdit do
  begin
    Parent   := ServersPage.Surface;
    Top      := IISCheckBox.Top;
    Left     := ApacheCheckBox.Left + 100;
    Width    := 200; 
    Height   := ScaleY( 25 );
    TabOrder := 1;
    Text     := 'c:\inetpub';
    Enabled  := IISCheckBox.checked;
    TabOrder := 8;
  end;

  IISButton := TButton.Create( ServersPage );
  with IISButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := IISEdit.Top - 2;
    Left     := IISEdit.Width + 140;
    Width    := 70;
    Height   := 25;
    Caption  := '&Browse...'
    OnClick  := @IISButtonClick;
    TabOrder := 9;
  end;

  IISInstallButton := TButton.Create( ServersPage );
  with IISInstallButton do
  begin
    Parent   := ServersPage.Surface;
    Top      := IISEdit.Top - 2;
    Left     := IISButton.Left + IISButton.Width + 10;
    Width    := 80;
    Height   := 25;
    Caption  := '&Install...'
    // OnClick  := @ApacheButtonClick;
    TabOrder := 4;
  end;

  ResultLabel := TLabel.Create( ServersPage );
  with ResultLabel do
  begin
    Parent   := ServersPage.Surface;
    Top      := IISEdit.Top  +  50;
    Left     := IISEdit.Left + 100;
    Caption  := 'Please select';
  end;

  ClockImage := TPanel.Create( ServersPage );
  with ClockImage do
  begin
    Parent     := ServersPage.Surface;
    Top        := ResultLabel.Top + 30;
    Left       := ResultLabel.Left;
    Height     := 150;
    BevelOuter := bvNone;
  end;
  
  cTmpFile1 := ExpandConstant( '{tmp}\info.txt' ); 
  Parameters := '(Invoke-WebRequest "localhost") >' + cTmpFile1;    

  if Exec( 'powershell.exe', Parameters, '', SW_HIDE, ewWaitUntilTerminated, retCode ) and FileExists( cTmpFile1 ) then
  begin  
    LoadStringFromFile( cTmpFile1, cHtml );
    ApacheCheckBox.checked := ( Pos( Wide( 'Apache' ), cHtml ) <> 0 );
    ApacheButton.enabled   := ( Pos( Wide( 'Apache' ), cHtml ) <> 0 );
    ApacheInstallButton.enabled := ( Pos( Wide( 'Apache' ), cHtml ) <> 0 );
    XamppCheckBox.checked  := ( Pos( Wide( 'Xampp' ), cHtml ) <> 0 );
    XamppButton.enabled    := ( Pos( Wide( 'Xampp' ), cHtml ) <> 0 );
    XamppInstallButton.enabled  := ( Pos( Wide( 'Xampp' ), cHtml ) <> 0 );
    IISCheckBox.checked    := ( Pos( Wide( 'IIS' ), cHtml ) <> 0 );
    IISButton.enabled      := ( Pos( Wide( 'IIS' ), cHtml ) <> 0 );
    IISInstallButton.enabled := ( Pos( Wide( 'IIS' ), cHtml ) <> 0 );
  end;

  DeleteFile( cTmpFile1 );
          
end;

procedure InitializeWizard();
begin
  AddServersPage();
end;

procedure CurStepChanged( CurStep: TSetupStep );
begin
  if CurStep = ssPostInstall then
  begin
   if ApacheCheckbox.checked then
   begin
    Exec( 'powershell.exe', 'Copy-Item ' + ExpandConstant( '{app}' ) + '\mod_harbour.so' + ' -Destination ' + ApacheEdit.Text + '\modules -recurse', '', SW_HIDE, ewWaitUntilTerminated, retCode ); 
    Exec( 'powershell.exe', 'Copy-Item ' + ExpandConstant( '{app}' ) + '\libharbour.dll' + ' -Destination ' + ApacheEdit.Text + '\htdocs -recurse', '', SW_HIDE, ewWaitUntilTerminated, retCode ); 
    Exec( 'powershell.exe', 'Add-Content ' + ApacheEdit.Text + '\conf\httpd.conf ' + '''Options FollowSymLinks Indexes''', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( 'powershell.exe', 'Add-Content ' + ApacheEdit.Text + '\conf\httpd.conf ' + '''LoadModule harbour_module modules/mod_harbour.so''', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( 'powershell.exe', 'Add-Content ' + ApacheEdit.Text + '\conf\httpd.conf ' + '''<FilesMatch "\.(prg|hrb)$">''', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( 'powershell.exe', 'Add-Content ' + ApacheEdit.Text + '\conf\httpd.conf ' + '''   SetHandler harbour''', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( 'powershell.exe', 'Add-Content ' + ApacheEdit.Text + '\conf\httpd.conf ' + '''</FilesMatch>''', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( 'powershell.exe', 'new-item -itemtype symboliclink -path ' + ApacheEdit.Text + '\htdocs -name modharbour_samples -value ' + ExpandConstant( '{app}' ) + '\samples', '', SW_HIDE, ewWaitUntilTerminated, retCode );
    Exec( ApacheEdit.Text + '\bin\httpd.exe', '', '', SW_HIDE, ewNoWait, retCode ); 
   end; 

   if IISCheckBox.checked then
   begin
    Exec( 'powershell.exe', '-ExecutionPolicy Bypass c:\windows\system32\inetsrv\appcmd.exe install module /name:mod_harbour /image:' + ExpandConstant( '{app}' ) + '\IIS\mod_harbour.dll', '', SW_HIDE, ewNoWait, retCode ); 
    MsgBox( intToStr( retCode ), mbInformation, 1 );
    Exec( 'powershell.exe', 'iisreset /restart', '', SW_HIDE, ewNoWait, retCode ); 
   end;
  end;
end;

[Run]
Filename: http://localhost/modharbour_samples/; Description: "Review mod_harbour samples"; Flags: postinstall shellexec
