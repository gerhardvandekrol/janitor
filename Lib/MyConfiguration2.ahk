#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
EnviDir = C:\Environments
EnviDir=%1%
;EnviDir= c:\Environments\Wartburg\FileServiceData ; for testing


;IfNotExist, C:\Environments
;    EnviDir = ::{20d04fe0-3aea-1069-a2d8-08002b30309d} ; My Computer

FileSelectFolder, SourceDir,%EnviDir%,0,Select folder to get your modified files and folders from.  ; 
if ErrorLevel  ; when you click on cancel
    GoSub, Sub2	
else
    
DaysBack=yyyymmdd
TargetDir=%SourceDir%\MyConfigurationSince_%DaysBack%
LogFile=MyConfigurationSince_%DaysBack%.log
ExcludeDirs=MyConfiguration* .git ScreenDesigner WorkflowDesigner Upload Images SendEmail Documenten
ExcludeFiles=MyConfiguration*.* *.auto.* *.rup
FormatTime, TimeString,%DaysBack%, LongDate

Gui, New  ; Creates a new GUI, destroying any existing GUI with that name.
Gui Add, GroupBox, x15 y5 w380 h40, Selected folder 
Gui, Add, Text,x15 y25 , %SourceDir% 
Gui Add, GroupBox, x10 y50 w380 h175, Date selection
Gui, Add, MonthCal, 16 vDaysBack x20 y70,
Gui, Add, Text,x190 y75 w190 ,Select from which day onward you would like to copy the files. The procedure will include all files with a timestamp of chosen date or newer.

Gui Add, GroupBox, x10 y230 w380 h80, Excluded folders 
Gui, Add, Edit,vNewDirList x20 y250 w360 h50, %ExcludeDirs%
;Gui, Add, Text, , Folders excluded from this action. Add or delete folders.

Gui Add, GroupBox, x10 y315 w380 h80, Excluded files 
Gui, Add, Edit,vNewFileList x20 y335 w360 h50, %ExcludeFiles%
;Gui, Add, Text,, Files excluded from this action. Add or delete files.

Gui Add, GroupBox, x10 y400 w380 h40, Target 
Gui, Add, Text,x15 y420 ,%TargetDir% 

Gui Add, GroupBox, x10 y445 w380 h55, Action
Gui, Add, Button, x25 y465 w140 h20 default, Copy  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Add, Button, x230 y465 w140 h20 , Close
;Gui, Add, Button, gCopy, Copy
Gui, Show,, MyConfiguration
return
ButtonClose:
ExitApp

ButtonCopy:
Gui, Submit  ; Save the input from the user to each control's associated variable.

if ErrorLevel  ; when you click on cancel
    GoSub, Sub2

;Copy:
;MsgBox, Hallo

TargetDir=%SourceDir%\MyConfigurationSince_%DaysBack%
LogFile=MyConfigurationSince_%DaysBack%.log

;MsgBox The current date (long format) is %TimeString%.
;MsgBox, %ExcludeDirs%`n %NewDirList%`n %NewFileList%

run, ROBOCOPY %SourceDir% %TargetDir% *.* /PURGE /S /NP /R:5 /LOG+:%LogFile% /TS /FP /XD %NewDirList% /XF %NewFileList% /MAXAGE:%DaysBack%

MsgBox Files and Folders changed or created since %DaysBack% have been copied to %SourceDir%\MyConfigurationSince_%DaysBack%. Check the logfile for details.`n (%TargetDir%\%LogFile%)
FileMove, %A_ScriptDir%\%LogFile%, %TargetDir%\

ExitApp
Sub2:
MsgBox, Bye.
ExitApp
