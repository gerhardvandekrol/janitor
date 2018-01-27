#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

EnviDir = C:\Environments
IfExist, C:\Environments\Klanten
EnviDir = C:\Environments\Klanten
IfExist, D:\Environments
EnviDir = D:\Environments
IfExist, D:\Environments\Klanten
EnviDir = D:\Environments\Klanten

;Read the Inifile of this project
SourceDir=NotSet

    IniFile =  %A_ScriptDir%\FSDChangeTracker_%A_ComputerName%.ini
IniRead, SourceDir, %IniFile%, FSDProject, SourceDir

DaysBack=yyyymmdd
TargetDir=%SourceDir%\FSD_Changes_Since_%DaysBack%
LogFile=FSD_Changes_Since_%DaysBack%.log
ExcludeDirs=FSD_Changes_* .git ScreenDesigner WorkflowDesigner Upload Images SendEmail Documenten
ExcludeFiles=FSD_Changes_*.* *.auto.* *.rup

FileGetTime, DeReleaseDatum_raw , %A_ScriptName%, M
FormatTime, DeReleaseDatum, DeReleaseDatum_raw, d-MMM-yyyy HH:mm

Gui, New  ; Creates a new GUI, destroying any existing GUI with that name.
Gui Add, GroupBox, x10 y5 w760 h45, Selected source folder 
Gui, Add, Text,x20 y25 , %SourceDir% 


Gui Add, GroupBox, x10 y55 w375 h175, Date selection
Gui, Add, MonthCal, 16 vDaysBack x20 y75,
Gui, Add, Text,x200 y75 w180 ,Select from which day onward you would like to copy the files. The procedure will include all files with a timestamp of chosen date or newer.`n`nFiles and folders can be excluded. Change the default settings if needed.

Gui Add, GroupBox, x390 y55 w380 h85, Excluded folders 
Gui, Add, Edit,vNewDirList x400 y75 w360 h55, %ExcludeDirs%
;Gui, Add, Text, , Folders excluded from this action. Add or delete folders.

Gui Add, GroupBox, x390 y145 w380 h85, Excluded files 
Gui, Add, Edit,vNewFileList x400 y165 w360 h55, %ExcludeFiles%
;Gui, Add, Text,, Files excluded from this action. Add or delete files.

Gui Add, GroupBox, x10 y235 w760 h45, Target 
Gui, Add, Text,x20 y255 ,%TargetDir% 

Gui Add, GroupBox, x10 y285 w760 h55, Actions
Gui, Add, Button, x20 y305 w200 h20 default, Copy  ; The label ButtonCopy (if it exists) will be run when the button is pressed.
Gui, Add, Button, gSelectSource x285 y305 w200 h20, Change source folder
Gui, Add, Button, x555 y305 w200 h20 , Close

Gui, Font, s6
Gui, Add, Link, x5 y345 w320 h10,  © SUT/GKL productions, <a href="http://www.bakkerbart.nl/">donationware</a>

Gui, Show, w780, %A_ScriptName%  -- A tool for retrieving your modified files from the FSD  --
return
ButtonClose:
ExitApp

ButtonCopy:
if DaysBack = yyyymmdd 
{
    MsgBox Select from which day onward you would like to copy the files
    GoSub, Reload
}

Gui, Submit  ; Save the input from the user to each control's associated variable.
if ErrorLevel  ; when you click on cancel
    GoSub, Sub2

TargetDir=%SourceDir%\FSD_Changes_Since_%DaysBack%
LogFile=FSD_Changes_Since_%DaysBack%.txt
FormatTime, TimeString,%DaysBack%, LongDate

;MsgBox, %ExcludeDirs%`n %NewDirList%`n %NewFileList%

run, ROBOCOPY %SourceDir% %TargetDir% *.* /PURGE /S /NP /R:5 /LOG+:%LogFile% /TS /FP /XD %NewDirList% /XF %NewFileList% /MAXAGE:%DaysBack%

MsgBox,  Files and Folders changed or created since %TimeString% have been copied to: `n`n %SourceDir%\FSD_Changes_Since_%DaysBack% `n`nCheck the logfile for details.
FileMove, %A_ScriptDir%\%LogFile%, %TargetDir%\
GoSub, Reload
return


SelectSource:
FileSelectFolder,SourceDir,%EnviDir%,0,Select folder to get your modified files and folders from. 
if ErrorLevel
    Return
IniWrite, %SourceDir%,%A_ScriptDir%\FSDChangeTracker_%A_ComputerName%.ini, FSDProject, SourceDir
GoSub, Reload
return

ReLoad:
IfExist %A_ScriptDir%\%A_ScriptName%
Run "%A_ScriptDir%\%A_ScriptName%"
return

Sub2:
MsgBox, Bye.
ExitApp
