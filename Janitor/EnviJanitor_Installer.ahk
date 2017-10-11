#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CanIGo=%1%

SourceJanitor = M:\SUT\_Templates & Documents\SUT SuperTools\EnvironmentJanitor
;SourceJanitor = C:\Users\Gerhard\Google Drive\AHK\Source\EnvironmentJanitor
InstallDir=%A_ScriptDir%\EnvironmentJanitor
LogDir = I:\GKL\EnviLog
;LogDir = D:\LogAHK


If CanIGo=Go
{
FileAppend, %A_Now%;Update;%A_UserName%;%A_ComputerName% `n, %LogDir%\EnviJanitorLog.txt
FileRemoveDir, %A_ScriptDir%\Lib, 1
FileDelete, %A_ScriptDir%\Janitor.ini
FileCopyDir, %SourceJanitor%, %A_ScriptDir%,1
FileCopyDir, %SourceJanitor%\Lib, %A_ScriptDir%\Lib,1
FileCopy, %SourceJanitor%\*.* , %A_ScriptDir%,1
MsgBox, The Environment Janitor has been updated, restarting  the Janitor....
Run %A_ScriptDir%\EnviJanitor.exe
ExitApp
}
Else
{
IfNotExist, %SourceJanitor%\*.*
    {
    MsgBox, Source not available. Installation only possible when connected to Ultimo network.
    ExitApp
    }
FileAppend, %A_Now%;Installation;%A_UserName%;%A_ComputerName% `n, %LogDir%\EnviJanitorLog.txt
MsgBox,64,Pick a folder, Pick a folder to install the Environment Janitor.
FileSelectFolder,InstallDir,,3,Select or create folder for installation.
    if ErrorLevel  ; when you click on cancel 
        Exit	
    else
FileCopyDir, %SourceJanitor%, %InstallDir%\EnvironmentJanitor,1
FileCopyDir, %SourceJanitor%\Lib, %InstallDir%\EnvironmentJanitor\Lib,1
FileCopy, %SourceJanitor%\*.* , %InstallDir%\EnvironmentJanitor,1
MsgBox,64,Installing, Installing Environment Janitor...
MsgBox,64, Creating, Creating shortcut on your desktop...
FileCreateShortcut, %InstallDir%\EnvironmentJanitor\EnviJanitor.exe, %A_Desktop%\Environment Janitor.lnk, , ,Run Environment Janitor, %InstallDir%\EnvironmentJanitor\Lib\favicon.ico
MsgBox,64, Finished, The Environment Janitor is installed in %InstallDir%\EnvironmentJanitor, starting the Janitor....
Run %InstallDir%\EnvironmentJanitor\EnviJanitor.exe
ExitApp
}


