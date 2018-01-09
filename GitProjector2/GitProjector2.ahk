#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Mydocs = %A_MyDocuments%
;MsgBox %Mydocs%

EnviDir = C:\Environments
IfExist, C:\Environments\Klanten
EnviDir = C:\Environments\Klanten
IfExist, D:\Environments
EnviDir = D:\Environments
IfExist, D:\Environments\Klanten
EnviDir = D:\Environments\Klanten

;Set right for running the batchfile
CanRunBatch = 0
CurrentUser = %A_UserName%
If CurrentUser in gvandekrol,msteenbakker
    CanRunBatch=1

;Read the local GPLocalSetting.ini
    IniFile =  %EnviDir%\GitProjector2\GPLocalSetting.ini
IniRead, EnviMap, %IniFile%, General, EnviMap
IniRead, SSHKey, %IniFile%, General, SSHKey


;Read the Inifile of this project
ClientName="Not set"
OrderId="Not set"
Version="Not set"
Backupname="Not set"
Sqlversion="Not set"

    IniFile =  %EnviDir%\GitProjector2\GPProjectSettings.ini
IniRead, ClientName, %IniFile%, GitProject, ClientName
IniRead, OrderId, %IniFile%, GitProject, OrderId
IniRead, Version, %IniFile%, GitProject, Version
IniRead, Version_2017R2, %IniFile%, GitProject, Version_2017R2
IniRead, Backupname, %IniFile%, GitProject, Backupname
IniRead, Sqlversion, %IniFile%, GitProject, Sqlversion

Gui, New
Gui Add, GroupBox, x10 y20 w480 h80 , Local settings
Gui, Add, Text, x30 y40 w100 h20 , Environments path
Gui, Add, Text, x130 y40 w300 h20 ,: %EnviMap%
Gui, Add, Text, x30 y60 w100 h20 , SSHKey
Gui, Add, Text, x130 y60 w300 h20 ,: %SSHKey%
Gui, Add, Button, gCreateIniLocalSettings x400 y35 w80 h20 , Settings

Gui Add, GroupBox, x10 y100 w480 h120 , Projects settings
Gui, Add, Text, x30 y120 w100 h20 , Clientname
Gui, Add, Text, x130 y120 w300 h20 ,: %ClientName%
Gui, Add, Text, x30 y140 w100 h20 , Ordernumber
Gui, Add, Text, x130 y140 w300 h20 ,: %OrderId%
Gui, Add, Text, x30 y160 w100 h20 , Version (xx.xx.xx)
Gui, Add, Text, x130 y160 w300 h20 ,: %Version%
Gui, Add, Text, x30 y180 w100 h20 , Via version (xx.xx.xx)
Gui, Add, Text, x130 y180 w300 h20 ,: %Version_2017R2%
Gui, Add, Text, x230 y120 w100 h20 , Backupname
Gui, Add, Text, x310 y120 w150 h20 ,: %Backupname%
Gui, Add, Text, x230 y140 w100 h20 , Sqlversion
Gui, Add, Text, x310 y140 w150 h20 ,: %Sqlversion%
Gui, Add, Button, gCreateIniProjectSettings x400 y160 w80 h20 , Settings
Gui, Add, Button, gResetProject x400 y185 w80 h20 , Reset project

if CanRunBatch = 1
Gui, Add, Tab2,x10 y220 w480 h115 , Actions|Actions2
Gui Add, GroupBox, x15 y240 w470 h90 
Gui, Add, Button, gRequestClone x30 y260 w300 h20 , Request clone for develop/%ClientName%-%OrderId%
;Gui, Add, Button, gSendEmail x370 y290 w100 h20 , Email

if CanRunBatch = 1
{
    Gui Tab, 2
    Gui Add, GroupBox, x15 y240 w470 h90 
    Gui, Add, Button, gBuildBatFile x30 y260 w100 h20 , Build Batchfile
    IfExist,  %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
    Gui, Add, Edit, x140 y245 w220 h80 ReadOnly, Clone_%ClientName%-%OrderId%.bat
    Gui, Add, Button, gViewBatchFile x30 y285 w100 h20 , View Batchfile
    Gui, Add, Button, gGetProject x400 y260 w80 h20 , Get project
    Gui, Add, Button, gRunBatchFile x400 y285 w80 h20 , Run Batchfile
}

Gui Tab 

Gui Add, GroupBox, x10 y340 w375 h70 , Help
Gui, Add, Text, x20 y355 w360 h45 ,This tool creates request for a batchfile that clones the repository git@gitlab.ishbv.nl:css/support-update-1.git with SutDefaults, creates a branch for the new project, prepares settings and update scripts.


Gui, Add, Button, x390 y345 w100 h65 , Close
Gui, Show, w500 h420, SUT GitProjectCreator2
return

GuiClose:
;ButtonOK:
;Gui, Submit  ; Save the input from the user to each control's associated variable.
ButtonClose:
    ExitApp

GetProject:
FileSelectFile, ProjectIni,,%A_ScriptDir%,Sutter projectIni
FileCopy, %ProjectIni%, %EnviDir%\GitProjector2\GPProjectSettings.ini,1
GoSub, Reload
return

RequestClone:
FileCreateDir  %A_ScriptDir%\%A_UserName%\%ClientName%-%OrderId%
FileCopy, %EnviDir%\GitProjector2\GPProjectSettings.ini, %A_ScriptDir%\%A_UserName%\%ClientName%-%OrderId%\GPProjectSettings.ini, 1
gosub, SendEmail
return

SendEmail:
Receipients= gerhard.vandekrol@ultimo.com;martijn.steenbakker@ultimo.com
LChoice = Beste Gerhard of Martijn,
 Oi = Request for GIT cloning repository %ClientName%-%OrderId%
 Ci = Email this request to Martijn and/or Gerhard. Settings for cloning project %ClientName%-%OrderId% in stored in %A_ScriptDir%\%A_UserName%\%ClientName%-%OrderId%\GPProjectSettings.ini<br> You will be notified a.s.a.p when the repository has been cloned.
 
Recipient := Receipients
Subject := Oi
Body := Ci
;Recipient3 = Updates@ultimo.com

;DocumentLocation = Z:\Menu\Email\NALivegang

;example of creating a MailItem and setting it's format to HTML
olMailItem := 0
MailItem := ComObjActive("Outlook.Application").CreateItem(olMailItem)
olFormatHTML := 2
MailItem.BodyFormat := olFormatHTML
MailItem.Subject := Subject
MailItem.HTMLBody := Body
Recipient := MailItem.Recipients.Add(Recipient)
Recipient.Type := 1 ; To: CC: = 2 BCC: = 3
;MailItem.bcc := Recipient3
MailItem.Display
Return

BuildBatFile:
TemplateSUTGitproject = \\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT SuperTools\SUTGitTemplate\TemplateSUTGitproject.txt
IfNotExist, \\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT SuperTools\SUTGitTemplate\TemplateSUTGitproject.txt
{
    MsgBox, %TemplateSUTGitproject% is not available. Batchbuilding only possible when connected to Ultimo network.
    Return
}

FileRead, TheTemplate, %TemplateSUTGitproject%
StringReplace, TheTemplate1, TheTemplate, GP_Customer, %ClientName%,
StringReplace, TheTemplate2, TheTemplate1, GP_Ordernumber, %OrderId%,
StringReplace, TheTemplate3, TheTemplate2, GP_Version, %Version%,
StringReplace, TheTemplate4, TheTemplate3, GP_Backupname, %Backupname%,
StringReplace, TheTemplate5, TheTemplate4, GP_Sqlversion, %Sqlversion%,
StringReplace, TheTemplate6, TheTemplate5, GP_SSHkey, %SSHKey%,
StringReplace, TheTemplate7, TheTemplate6, C:\Environments, %EnviMap%,All
StringReplace, TheTemplate8, TheTemplate7, GP_version_2017R2, %Version_2017R2%,
FileDelete, %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
FileAppend, %TheTemplate8%, %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
GoSub, Reload
return

ResetProject:
FileDelete, %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
FileDelete, %EnviDir%\GitProjector2\GPProjectSettings.ini
GoSub, Reload
return

ViewBatchFile:
Run Notepad++.exe %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
Return

RunBatchFile:
RunWait %EnviDir%\GitProjector2\Clone_%ClientName%-%OrderId%.bat
Return

CreateIniLocalSettings:
FileSelectFolder, InputEnviMap,,0, Choose your local Environment folder
if ErrorLevel
    Return
MsgBox Next select the local sshkey for GITExt
FileSelectFile, InputSSHKey ,,,Select your local SSHkey for GIT.
if ErrorLevel
    Return
FileCreateDir, %EnviDir%\GitProjector2
IniWrite, %InputEnviMap%,%EnviDir%\GitProjector2\GPLocalSetting.ini, General, EnviMap
IniWrite, %InputSSHKey%, %EnviDir%\GitProjector2\GPLocalSetting.ini, General, SSHKey
MsgBox %EnviDir%\GitProjector2\GPLocalSetting.ini
GoSub, Reload
return


CreateIniProjectSettings:
InputBox, InputClientName, Customer name, Enter customer name (do not use spaces) ,,300,150,800,300,,,%ClientName%
if ErrorLevel
    Return
InputBox, InputOrderIn, Order number, Enter order number,,300,150,820,320,,,%OrderId%
if ErrorLevel
    Return
InputBox, InputVersion, Version , Enter Ultimo target version (ie 17.10.xx) ,,300,150,840,340,,,%Version%
if ErrorLevel
    Return
InputBox, InputVersion_2017R2, Version , Enter highest 2017R2 (17.04) version ,,300,150,840,340,,,%Version_2017R2%
if ErrorLevel
    Return
InputBox, InputBackupname, Backupname, Enter backupname (without .bak) ,,300,150,860,360,,,%Backupname%
if ErrorLevel
    Return
InputBox, InputSqlversion, Sql version, Enter Sql version ,,300,150,880,380,,,%Sqlversion%
if ErrorLevel
    Return
IniWrite, %InputClientName%,%EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, ClientName
IniWrite, %InputOrderIn%, %EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, OrderId
IniWrite, %InputVersion%, %EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, Version
IniWrite, %InputBackupname%, %EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, Backupname
IniWrite, %InputSqlversion%, %EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, Sqlversion
IniWrite, %InputVersion_2017R2%, %EnviDir%\GitProjector2\GPProjectSettings.ini, GitProject, Version_2017R2
GoSub, Reload
return

ReLoad:
IfExist %A_ScriptDir%\GitProjector2.exe
Run "%A_ScriptDir%\GitProjector2.exe"
IfExist %A_ScriptDir%\GitProjector2.ahk
Run "%A_ScriptDir%\GitProjector2.ahk"
return