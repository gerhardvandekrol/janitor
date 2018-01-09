#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

FormatTime, TimeString, A_Now, d-MMM-yyyy HH:mm

IniWrite, %TimeString%,%A_ScriptDir%\Janitor\Janitor.ini, General, Version

FileRemoveDir, %A_ScriptDir%\EnvironmentJanitor, 1
FileCopyDir, %A_ScriptDir%\Janitor, %A_ScriptDir%\EnvironmentJanitor
FileRead, TheText,%A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk
StringReplace, NewText, TheText, .ahk, .exe, All 
FileDelete, %A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk
FileAppend, %NewText%, %A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk

FileRead, TheText,%A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk
StringReplace, NewText, TheText, DeReleaseDatum, %TimeString%, All 
FileDelete, %A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk
FileAppend, %NewText%, %A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk

RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\EnviJanitor.exe" /icon "%A_ScriptDir%\EnvironmentJanitor\Lib\favicon.ico"
RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\EnviJanitor_Installer.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\EnviJanitor_Installer.exe" /icon "%A_ScriptDir%\EnvironmentJanitor\Lib\favicon.ico"
FileDelete,%A_ScriptDir%\EnvironmentJanitor\EnviJanitor.ahk
FileDelete,%A_ScriptDir%\EnvironmentJanitor\EnviJanitor_Installer.ahk

RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts2.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts2.exe" 
RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts1700.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts1700.exe" 
RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\Lib\MyConfiguration2.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\Lib\MyConfiguration2.exe" 
RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\Lib\SetLanguages2.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\Lib\SetLanguages2.exe" 
RunWait Ahk2Exe.exe /in "%A_ScriptDir%\EnvironmentJanitor\Lib\SwitchRecordAuthorization.ahk" /out "%A_ScriptDir%\EnvironmentJanitor\Lib\SwitchRecordAuthorization.exe" 
FileDelete,%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts2.ahk
FileDelete,%A_ScriptDir%\EnvironmentJanitor\Lib\GetUpdateScripts1700.ahk
FileDelete,%A_ScriptDir%\EnvironmentJanitor\Lib\MyConfiguration2.ahk
FileDelete,%A_ScriptDir%\EnvironmentJanitor\Lib\SetLanguages2.ahk
FileDelete,%A_ScriptDir%\EnvironmentJanitor\Lib\SwitchRecordAuthorization.ahk


MsgBox, 4, Ready, EnvironmentJanitor is compiled. Copy to Shared SUT drive?
      IfMsgBox Yes
        FileCopyDir, %A_ScriptDir%\EnvironmentJanitor, \\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT SuperTools\EnvironmentJanitor,1
     else 
    MsgBox, Bye