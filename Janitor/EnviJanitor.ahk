#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SourceDir= %1%  ;Used for reload

EnviDir = C:\Environments
IfExist, C:\Environments\Klanten
EnviDir = C:\Environments\Klanten
IfExist, D:\Environments
EnviDir = D:\Environments
IfExist, D:\Environments\Klanten
EnviDir = D:\Environments\Klanten

;Read the local Janitor.ini
;Version=
    IniFile =  %A_ScriptDir%\Janitor.ini
IniRead, LocalVersion, %IniFile%, General, Version

If  SourceDir = ; Only ask for Environment when started or changed environment
FileSelectFolder, SourceDir,%EnviDir%,0,Select a folder from your environment manager. Make sure this is a complete environment.  ; Ask the user to pick a Environment
if ErrorLevel  ; when you click on cancel 
    GoSub, Sub2	
else
IfNotExist, %SourceDir%\FileServiceData\*.* 
    MsgBox, 4, Not a environment, %SourceDir% is not a valid Ultimo environment. At least the folder FileServiceData should exist. Try again?
       IfMsgBox Yes
        GoSub, GetNewEnvi 
     else 

; LicenceFile information
FileRead, xmldata,  %SourceDir%\FileServiceData\License\License.lic
doc := ComObjCreate("MSXML2.DOMDocument.6.0")
doc.async := false
doc.loadXML(xmldata)
    DocNode := doc.selectSingleNode("//ContractType")
    ContractType := DocNode.text
    DocNode := doc.selectSingleNode("//Owner/Name")
    Name := DocNode.text
    DocNode := doc.selectSingleNode("//UserLimit")
    UserLimit := DocNode.text
    DocNode := doc.selectSingleNode("//Product")
    Product := DocNode.text

; Database Information
DatabaseServerName="Not set"
DatabaseName="Not Set"
IfExist, %SourceDir%\Website\Config\DataService.Config
{
FileReadLine,DirtyDatabaseName, %SourceDir%\Website\Config\DataService.Config,3
StringTrimLeft, DirtyDatabasename1, DirtyDatabaseName, 23
StringTrimRight, DatabaseName, DirtyDatabasename1, 4
FileReadLine,DirtyDatabaseServerName, %SourceDir%\Website\Config\DataService.Config,4
StringTrimLeft, DirtyDatabaseServerName1, DirtyDatabaseServerName, 29
StringTrimRight, DatabaseServerName, DirtyDatabaseServerName1, 4
}

;Read the Inifile of this environment
ClientId="Not set"
OrderId="Not set"
SutCheckList="Not set"
ItaList="Not set"
;IfExist, %SourceDir%\EnviJanitor.ini
    IniFile =  %SourceDir%\EnviJanitor.ini
IniRead, ClientId, %IniFile%, Inside, ClientId
IniRead, OrderId, %IniFile%, Inside, OrderId
IniRead, SutCheckList, %IniFile%, Inside, SutCheckList
IniRead, ItaList, %IniFile%, Inside, ItaList

;The URL for this environment
urlUltimo=http://%A_ComputerName%:15000/%DatabaseName%
urlUltimoUCT=http://%A_ComputerName%:15000/%DatabaseName%/UCT


Gui, New  ; Creates a new GUI, destroying any existing GUI with that name.
Gui, Add, Picture, x0 y0 h60 w300, Lib\ultimo_SUT_wide.png
Gui, Add, Picture, gUltimoIE x380 y20 w20 h20, Lib\1488146676_internet-explorer.ico
Gui, Add, Picture, gUltimoChrome x420 y20 w20 h20, Lib\1488146684_chrome.ico
Gui, Add, Picture, gUltimoFireFox x460 y20 w20 h20, Lib\1488146763_firefox.ico
Gui Add, GroupBox, x10 y55 w480 h45, Environment
Gui, Add, Text, x20 y75 w375 h20 cBlue, %SourceDir%
Gui, Add, Button,gGetNewEnvi x300 y70 w120 h20 Default , Change environment
Gui, Add, Button,gOpenFolder x425 y70 w60 h20 , Explore


Gui, Add, Tab3,x10 y105 w480 h470 , General|Settings|About
Gui Add, GroupBox, x20 y130 w345 h100 , License
Gui, Add, Text, x30 y150 w90 h20 , Relation 
Gui, Add, Text, x110 y150 w230 h20 , : %Name% 
Gui, Add, Text, x30 y165 w90 h20 , Contract Type
Gui, Add, Text, x110 y165 w150 h20 , : %ContractType%
Gui, Add, Text, x30 y180 w90 h20 , Product
Gui, Add, Text, x110 y180 w50 h20 , : %Product%
Gui, Add, Text, x30 y195 w90 h20 , UserLimit
Gui, Add, Text, x110 y195 w50 h20 , : %UserLimit%
Gui, Add, Button,gOpenLicFile x280 y205 w80 h20 , View License

Gui Add, GroupBox, x370 y130 w110 h100 , Order
Gui, Add, Text, x380 y150 w45 h20 , Relation 
If  ClientId  <> ERROR
Gui, Add, Link, x420 y150 w45 h20,: <a href="https://inside.ultimo.com/ultimo.aspx#screen/3f051ba2-032c-47b0-b2d3-5275aea9da69?cusid=%ClientId%&screenmode=history&storeKey=history_1486897863619">%ClientId%</a>  
Gui, Add, Text, x380 y165 w45 h20 , Order
If  OrderId  <> ERROR
Gui, Add, Link, x420 y165 w45 h20,: <a href="https://inside.ultimo.com/ultimo.aspx#screen/7edc0728-b1b2-45c3-e1f7-f8d8d824a2dd?_ordid=%OrderId%&screenmode=history&storeKey=history_1486898127391">%OrderId%</a>  
If  SutCheckList  <> ERROR
Gui, Add, Button,gOpenSutCheckList x375 y185 w100 h20 ,SUT Checklist
If  ItaList  <> ERROR
Gui, Add, Button,gOpenItaList x375 y205 w100 h20 ,Ita-list

Gui Add, GroupBox, x20 y230 w460 h100, Database
Gui, Add, Text, x30 y250 w75 h20 , Instance
Gui, Add, Text, x110 y250 w250 h20 , : %DatabaseServerName%
Gui, Add, Text, x30 y265 w75 h20 , Database
Gui, Add, Text, x110 y265 w250 h20 , : %DatabaseName%
Gui, Add, Button,gRunSqlScript x330 y250 w140 h20 , QuickScan Environment
Gui, Add, Button,gSetUMMPasswordSqlScript x330 y275 w140 h20 , Reset passwords
Gui, Add, Button,gRunScriptSPARAMETERVALUE x330 y300 w140 h20 , SPARAMETERVALUE
Gui, Add, Button,gBackupDatabase x30 y300 w140 h20 , Backup Database

Gui Add, GroupBox, x20 y340 w225 h230, Environment maintenance
Gui, Add, Button,gGo5 x30 y360 w125 h20 , Get updatescripts
Gui, Add, Button,gGo1700Scripts x160 y360 w80 h20 , >= 17.10
Gui, Add, Button,gGo6 x30 y385 w125 h20 , Update environment 
Gui, Add, Button,gGo8 x30 y410 w125 h20 , Change language
Gui, Add, Button,gGo9 x30 y435 w125 h20 , Record Authorization
Gui, Add, Button,gAddUCTCertificate x30 y460 w125 h20 , Add UCT certificate
Gui, Add, Button, gCreateMain x30 y485 w125 h20 , Create batchscript
Gui, Add, Button, gCreateArchive x30 y510 w125 h20 , Create archive

Gui Add, GroupBox, x255 y340 w225 h100, FileServiceData maintenance
Gui, Add, Button,gGo1 x265 y360 w125 h20 , Cleanup
Gui, Add, Button,gHelp1 x390 y360 w15 h20, ?
Gui, Add, Button,gGo2 x265 y385 w125 h20 , Copy Fileservicedata
Gui, Add, Button,gGo3 x390 y385 w80 h20 , Zip it!
Gui, Add, Button,gGo4 x265 y410 w125 h20 , Delete FSDtoDeploy

Gui Add, GroupBox, x255 y440 w225 h60, Copy configuration
Gui, Add, Button,gGo7 x265 y460 w125 h20 , MyConfiguration
Gui, Add, Button, gHelp2 x390 y460 w15 h20, ?

Gui Tab, 2
Gui Add, GroupBox, x20 y130 w440 h240 , Settings
Gui, Add, Text, x30 y150 w60 h20, Relation
Gui, Add, Text, x90 y150 w100 h20, : %ClientId% 
Gui, Add, Text, x30 y170 w60 h20, Order
Gui, Add, Text, x90 y170 w100 h20, : %OrderId%
Gui, Add, Text, x30 y190 w70 h20, Checklist
Gui, Add, Edit, x90 y190 w360 h40 ReadOnly, %SutCheckList%
Gui, Add, Text, x30 y230 w70 h20, ITA-list
Gui, Add, Edit, x90 y230 w360 h40 ReadOnly, %ItaList%
Gui, Add, Button, gCreateIni x30 y330 w100 h20 , Set values
;Gui, Add, Button, gReLoad x250 y285 w100 h20 , Reload Janitor

Gui Tab, 3
Gui Add, GroupBox, x20 y130 w270 h280 , About this tool
Gui, Add, Text, x30 y150 w250 h80, The environment janitor is a project to accommodate the SUT team. It provides a set of tools, functions and shortcuts that fail at the Environment Manager. These features may also be helpful for other heavy users of the Environment Manager. 
Gui, Add, Link, x30 y225 w250 h40, This tool is free to use and distribute. <a href="http://www.bakkerbart.nl/">Donations</a> and suggestions are appreciated. 
Gui, Add, Text, x30 y265 w250 h40 , You are using version %LocalVersion% of the Environment Janitor
Gui, Add, Button, gUpdate x30 y300 w250 h30 , Check for newer version
Gui, Add, Button, gSendEmail x30 y340 w250 h20 , Suggestions
Gui, Add, Button, gShareJanitor x30 y370 w250 h20 , Share the Janitor

Gui Tab,4
Gui Add, GroupBox, x20 y130 w440 h240 , Backlog
Gui, Add, Button, x30 y150 w140 h20 , Copy Folder Template
Gui, Add, Button, x30 y175 w140 h20 , Get MenuClassic
Gui, Add, Button, x30 y200 w140 h20 , Get Statemachines

Gui, Tab
Gui, Font, s6
Gui, Add, Link, x3 y590 w320 h10,  © SUT/GKL productions, <a href="http://www.bakkerbart.nl/">donationware</a>, release DeReleaseDatum

Gui, Font, s8
Gui, Add, Button, x390 y575 w100 h20 , Close
;Gui, Add, Button, x290 y575 w100 h20 , Submit
;Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, Environment Janitor
return

GuiClose:
;ButtonOK:
;Gui, Submit  ; Save the input from the user to each control's associated variable.
ButtonClose:
    ExitApp

Update:
;SourceJanitor = C:\Users\Gerhard\Google Drive\AHK\Source\EnvironmentJanitor
SourceJanitor = \\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT SuperTools\EnvironmentJanitor
IfNotExist, %SourceJanitor%\*.*
{
    MsgBox, Source not available. Installation only possible when connected to Ultimo network.
    Return
}
;Read the remote Janitor.ini
    IniFile =  %SourceJanitor%\Janitor.ini
IniRead, RemoteVersion, %IniFile%, General, Version
FileCopy,%SourceJanitor%\EnviJanitor_Installer.ahk, %A_ScriptDir%,1
;MsgBox, %RemoteVersion%  - %LocalVersion%
If (RemoteVersion != LocalVersion)
{
MsgBox,4, Update,A newer version  (%RemoteVersion%)  is available.  Would you like to update?
    IfMsgBox Yes
        {
        Run "%A_ScriptDir%\EnviJanitor_Installer.ahk" "Go"
        ExitApp
        }
    IfMsgBox, No
    Return
} 
Else
{
MsgBox, No update necessary, you are using the latest version of the Environment Janitor
}
return


UltimoIE:
Pwb :=  ComObjCreate("InternetExplorer.Application")
Pwb.Visible:=True
Pwb.Navigate(urlUltimo)
Return

UltimoChrome:
Run, Chrome.exe %urlUltimo%
return

UltimoFireFox:
Run, FireFox.exe %urlUltimo%
return


CreateMain:
FileSelectFolder, WhichFolder,%EnviDir%,0,Select folder to mainscript.  ; Ask the user to pick or create a scriptfolder to update.
if ErrorLevel  ; i.e. it's not blank or zero.
    return
else
FileList =  ; Initialize to be blank.

Loop, Files, %WhichFolder%\*.sql,R
    FileList = %FileList%:r %A_LoopFileFullPath%`n
Sort, FileList   ; The R option sorts in reverse order.

FileDelete, %WhichFolder%\main.sql
FileAppend, :ON ERROR EXIT`n, %WhichFolder%\main.sql
FileAppend, %FileList%`n, %WhichFolder%\main.sql
MsgBox,,Ready, Main.sql is created. Run script in SQLCMD mode.
Exit

SendEmail:
m := ComObjCreate("Outlook.Application").CreateItem(0)
m.Subject := "Environment Janitor - Suggestions and bugs"
m.To := "gerhard.vandekrol@ultimo.com"
m.Body := "I have been using the Environment Janitor and I have the following suggestions and/or bugs to report`n`n 1.`n 2.`n 3.`n`n Kind regards`n"
m.Display ;to display the email message...and the really cool part, if you leave this line out, it will not show the window............... but the m.send below will still send the email!!!
;m.Attachments.add(Attach)
;m.Send ;to automatically send and CLOSE that new email window...
return

ShareJanitor:
RunWait %A_ScriptDir%\Lib\7za.exe a -tzip "EnviJanitor_Installer.zip" "EnviJanitor_Installer.exe" -mx5
Attach = %A_ScriptDir%\EnviJanitor_Installer.zip
m := ComObjCreate("Outlook.Application").CreateItem(0)
m.Subject := "Environment Janitor"
;m.To := "gerhard.vandekrol@ultimo.com"
m.Body := "The environment janitor is a project to accommodate the SUT team. It provides a set of tools, functions and shortcuts that fail at the Environment Manager. These features may also be helpful for other heavy users of the Environment Manager.`n`nUnzip attached file and run it on you pc. You will need to have access to the Ultimo network during installation or update."
m.Display ;to display the email message...and the really cool part, if you leave this line out, it will not show the window............... but the m.send below will still send the email!!!
m.Attachments.add(Attach)
;m.Send ;to automatically send and CLOSE that new email window...
FileDelete EnviJanitor_Installer.zip
return

GetNewEnvi:
SourceJanitor = \\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT SuperTools\EnvironmentJanitor
IfExist, %SourceJanitor%\*.*
{
    IniFile =  %SourceJanitor%\Janitor.ini
    IniRead, RemoteVersion, %IniFile%, General, Version
    ;MsgBox, %RemoteVersion%  - %LocalVersion%
        If (RemoteVersion != LocalVersion)
            {
                MsgBox,4, Update,A newer version  (%RemoteVersion%)  is available.  Would you like to update?
                IfMsgBox Yes
                {
                Run "%A_ScriptDir%\EnviJanitor_Installer.ahk" "Go"
                ExitApp
                }
                IfMsgBox, No
                Reload
            }
} 
Else
{
  Reload
}
Reload
;Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
;MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
;IfMsgBox, Yes, Edit
return

ReLoad:
Run "%A_ScriptDir%\EnviJanitor.ahk" "%SourceDir%"
return

CreateIni:
InputBox, InputClientId,Client number, Enter Client number,,200,150,800,300,,,%ClientId%
if ErrorLevel
    Return
InputBox, InputOrderIn, Order number, Enter Order number,,200,150,820,320,,,%OrderId%
if ErrorLevel
    Return
;InputBox, InputSutCheckList, , Enter Order number,,200,150,820,320,,,%SutCheckList%
FileSelectFile, InputSutCheckList ,,%SourceDir%, Select the SUT Checklist for this project 
if ErrorLevel
    Return
FileSelectFile, InputItaList ,,%SourceDir%, Select the ITA-list for this project 
if ErrorLevel
    Return
IniWrite, %InputClientId%,%SourceDir%\EnviJanitor.ini, Inside, ClientId
IniWrite, %InputOrderIn%, %SourceDir%\EnviJanitor.ini, Inside, OrderId
IniWrite, %InputSutCheckList%, %SourceDir%\EnviJanitor.ini, Inside, SutCheckList
IniWrite, %InputItaList%, %SourceDir%\EnviJanitor.ini, Inside, ItaList
GoSub, Reload
return

Help1:
MsgBox,32, Help, Clean-up the FileServiceData: `n - delete folder ScreenDesigner`n - delete folder WorkflowDesigner`n - delete autopackages`n`nCopy folder FileServiceData to folder FSDToDeploy`n`n Zip the folder FSDToDeploy `n`n Delete the folder FSDToDeploy
Return

Help2:
MsgBox,32, Help, Copy the files with a selectable timestamp or later to a seperate folder. Perfect for deploying your work of the day from Test to Production.
Return

OpenFolder:
Run Explorer %SourceDir%
Return

OpenSutCheckList:
Run Excel.exe %SutCheckList%
Return

OpenItaList:
Run Excel.exe %ItaList%
Return

OpenLicFile:
Run Notepad++.exe  %SourceDir%\FileServiceData\License\License.lic
Return

CreateArchive:
FormatTime, DateString, A_Now, yyyyMMdd
TargetDir=%SourceDir%\%ClientID%_P_%DateString%
FileCreateDir, %TargetDir%
MsgBox,4, Backup database ready, Did you create a backup from the database?
    IfMsgBox No
    {
        gosub BackupDatabase
    }
FileSelectFile, SelectedDB,,%SourceDir%,Select the backupfile you would like to archive,*.bak
    if ErrorLevel  ; when you click on cancel 
       Return
FileCopy, %SelectedDB%, %TargetDir%, 1
MsgBox,  %SelectedDB% copied to %TargetDir%
MsgBox,4,Continue,Continue with FileServiceData?
    IfMsgBox, No
        Return
    
ExludeDirs=MyConfiguration* .git ScreenDesigner Upload Images SendEmail Documenten WorkflowDesigner
ExcludeFiles=MyConfiguration*.*
runwait, ROBOCOPY %SourceDir%\FileServiceData %TargetDir%\FileServiceData *.* /PURGE /S /NP /R:5 /TS /FP /XD %ExludeDirs% /XF %ExcludeFiles%
MsgBox, FileServiceData copied to %TargetDir%`n`nExluded folders: %ExludeDirs%
MsgBox,4,Zip this, Would you like to zip this?
    IfMsgBox, No
        Return
RunWait %A_ScriptDir%\Lib\7za.exe a -tzip "%SourceDir%\%ClientID%_P_%DateString%.zip" "%TargetDir%" -mx5   
MsgBox,4, Copy this, Environment is zipped as %SourceDir%\%ClientID%_P_%DateString%.zip, move to Network?
    IfMsgBox, No
        Return
FileSelectFolder, SelectedFolder, , ,Browse to folder to store this archive.
FileMove, %SourceDir%\%ClientID%_P_%DateString%.zip, %SelectedFolder%
FileRemoveDir,%TargetDir%,1
MsgBox,,Ready, Zip file moved to %SelectedFolder%. Temporary folder %TargetDir% is removed.
return

RunSqlScript:
RunWait sqlcmd -S %DatabaseServerName% -U sa -P s  -d %DatabaseName%  -i "%A_ScriptDir%\Lib\Sql\ScanEnvi.sql"  -o  "%SourceDir%\ScanEnvi.txt"
RunWait NotePad %SourceDir%\ScanEnvi.txt
FileDelete %SourceDir%\ScanEnvi.txt
Return

SetUMMPasswordSqlScript:
MsgBox, 4, Password Reset, Passwords for Ummadmin and Ultimo will be reset to 's' for environment %Name%.  `n `n Would you like to continue?
IfMsgBox Yes
RunWait sqlcmd -S %DatabaseServerName% -U sa -P s  -d %DatabaseName%  -i "%A_ScriptDir%\Lib\Sql\ResetUmmadminAndUltimo.sql"  ;-o  "%SourceDir%\ScanEnvi.txt"
Return

RunScriptSPARAMETERVALUE:
RunWait sqlcmd -S %DatabaseServerName% -U sa -P s  -d %DatabaseName%  -i "%A_ScriptDir%\Lib\Sql\ScriptSPARAMETERVALUE.sql"  -o  "%SourceDir%\ScriptSPARAMETERVALUE.sql"
RunWait NotePad++.exe %SourceDir%\ScriptSPARAMETERVALUE.sql
FileDelete %SourceDir%\ScriptSPARAMETERVALUE.sql
Return

BackupDatabase:
FormatTime, TimeString, A_Now, yyyyMMdd_HHmm
MsgBox, 4, Database Backup, Backup will be stored at %SourceDir%\Data\%DatabaseName%_%TimeString%.bak.  `n `n Would you like to continue?
IfMsgBox Yes
RunWait Sqlcmd  -S %DatabaseServerName%  -U sa -P s -Q "BACKUP DATABASE [%DatabaseName%] TO DISK = '%SourceDir%\Data\%DatabaseName%_%TimeString%.bak'"
Return


Go1: ;Cleanup FileServiceData
FileRemoveDir, %SourceDir%\FileServiceData\WorkflowDesigner,1
FileRemoveDir, %SourceDir%\FileServiceData\ScreenDesigner,1
FileDelete, %SourceDir%\FileServiceData\Packages\*.auto.*
MsgBox %SourceDir% has been cleaned up!
;Else
Return

Go2: ;Copy FileServiceData
TargetDir=%SourceDir%\FSDtoDeploy
LogFile=%SourceDir%\FSDtoDeploy.log
ExludeDirs=MyConfiguration* .git ScreenDesigner Upload Images SendEmail Documenten WorkflowDesigner
ExcludeFiles=MyConfiguration*.*
;FormatTime, TimeString,%DaysBack%, ShortDate
runwait, ROBOCOPY %SourceDir%\FileServiceData %TargetDir% *.* /PURGE /S /NP /R:5 /LOG+:%LogFile% /TS /FP /XD %ExludeDirs% /XF %ExcludeFiles%
MsgBox, FileServiceData copied to %SourceDir%\FSDtoDeploy`nExluded folders: %ExludeDirs%
Return

Go3: ;Zip It
FormatTime, TimeString, A_Now, yyyyMMdd_HHmm
	;SetWorkingDir %SourceDir%
	RunWait %A_ScriptDir%\Lib\7za.exe a -tzip "%SourceDir%\FSDtoDeploy_%TimeString%.zip" "%SourceDir%\FSDtoDeploy" -mx5
    ;runwait, zip.exe -r FSDtoDeploy_%TimeString%.zip FSDtoDeploy
	MsgBox %SourceDir%\FSDtoDeploy_%TimeString%.zip has been created.
Return

Go4: ;Delete FSDtoDeploy
	FileRemoveDir,%SourceDir%\FSDtoDeploy,1
	MsgBox %SourceDir%\FSDtoDeploy has been deleted.
Return

Go5: ;Get updatescripts
RunWait "%A_ScriptDir%\Lib\GetUpdateScripts2.ahk" "%SourceDir%"
MsgBox,4,1700 Scripts, Get the 1700 scripts too?
    IfMsgBox Yes
        Run "%A_ScriptDir%\Lib\GetUpdateScripts1700.ahk" "%SourceDir%"
        Return
Return

Go1700Scripts: ;Get updatescripts for 1710
Run "%A_ScriptDir%\Lib\GetUpdateScripts1700.ahk" "%SourceDir%"
Return

Go6: ;Update environment
InputBox,Version, Update Environment, Get Website en Services folders from version:`n(Make sure that environment is not running during the update),,300,,,,,,xx.xx.xx ;What is the version we should copy from the server.
if ErrorLevel  ; i.e. it's not blank or zero.
    Return	
else 	
; The progressbar while we are getting the files from the server.	
IfExist, Lib\ultimo_SUT_wide.png, SplashImage, Lib\ultimo_SUT_wide.png, A ,this might take a while.... be patient...,Updating %SourceDir% to %Version%, Updating
	
FileRemoveDir, %SourceDir%\Website, 1 ; deleting the current files from the directory
;FileCopyDir, C:\Environments\DemoUFM21\Services\ServiceHost, %SourceDir%\Website  ;for testing purposes
FileCopyDir, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Website, %SourceDir%\Website  ; copy the desired files from the server.
FileRemoveDir, %SourceDir%\Services, 1
FileCopyDir, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Services, %SourceDir%\Services
Progress, Off	
MsgBox Website and Services folders of %SourceDir% have been replaced with version %Version%. Thank you for using this awesome tool!
Return
Sub3:
    MsgBox, Thanks for using the Environment Janitor.
    Exit
Return

Go7: ;MyConfiguration
Run "%A_ScriptDir%\Lib\MyConfiguration2.ahk" "%SourceDir%"
Return

Go8: ;Change language
Run "%A_ScriptDir%\Lib\SetLanguages2.ahk" "%SourceDir%"
return

Go9: ;Switch Record Authorization
Run "%A_ScriptDir%\Lib\SwitchRecordAuthorization.ahk" "%SourceDir%"
return

AddUCTCertificate:
IfNotExist, C:\UCTcertificate
	{
	MsgBox, Place you personal UCT Certificate in C:\UCTcertificate.
	return
	}
Directory = C:\UCTcertificate
Loop %Directory%\*.xml
{
	CertFileName = %A_LoopFileName%
}

IfExist, C:\UCTcertificate\%CertFileName%
{
    c:=1
}
else
{
    c:=0
}

IfExist, %SourceDir%\FileServiceData\License\Certificates.xml
{
    d:=1
}
else
{
    d:=0
}
;Add certificate to environment
if (c=1 && d=0) {
	;MsgBox, crt niet gevonden
	FileRead, Certificate, C:\UCTcertificate\%CertFileName%
	;MsgBox, %Certificate%
	FileCreateDir, %SourceDir%\FileServiceData\License\
	FileAppend, <?xml version="1.0" encoding="utf-8"?> `n <Certificates> `n   %Certificate% </Certificates>, %SourceDir%\FileServiceData\License\Certificates.xml
} else if (c=1 && d=1) {	
	FileRead, Certificate, C:\UCTcertificate\%CertFileName%
	PathToXml  = %SourceDir%\FileServiceData\Certificates.xml
	FileRead, CertOverview,  %SourceDir%\FileServiceData\License\Certificates.xml
	;MsgBox test %CertOverview%
	StringReplace, CertResult, CertOverview, </certificates>, %Certificate% `n </Certificates>	
	;MsgBox, %CertResults%
	FileDelete, %SourceDir%\FileServiceData\License\Certificates.xml
	FileAppend, %CertResult%, %SourceDir%\FileServiceData\License\Certificates.xml
}
MsgBox,,Ready, Your personal certificate is added to the environment.
return


ExitApp
Sub2:
MsgBox, Thanks for using the Environment Janitor.
ExitApp
