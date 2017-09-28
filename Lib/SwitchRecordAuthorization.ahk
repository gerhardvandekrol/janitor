#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SourceDir= %1%

FileReadLine,FoundSetting, %SourceDir%\Website\Config\Ultimo.Web.Config,3

Gui, New
Gui, Add, Picture, x0 y0 h99 w500, ultimo_SUT_wide.png
Gui, Add, Text,x30 y100 w500 h20, You selected %SourceDir%  
Gui, Add, Text,x30 y120 w500 h20, Found setting %FoundSetting%
Gui, Add, Radio, Checked vSetRecAuthTo, Set authorization to <add key="RecordAuthorization" value="Record_Authorization"/>
Gui, Add, Radio, , Set authorization to <add key="RecordAuthorization" value=""/>

Gui, Add, Button, x410 y230 w60 h20 default, Close  ; The label ButtonClose (if it exists) will be run when the button is pressed.
Gui, Add, Button, x345 y230 w50 h20 default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.

Gui, Show, AutoSize Center, SUT Supertools Record authorization switcher
return

ButtonOK:
Gui, Submit
;MsgBox %SetLangTo% 

if (SetRecAuthTo = 1) { 
NewSetting = <add key="RecordAuthorization" value="Record_Authorization"/>
}
else if (SetRecAuthTo = 2) { 
NewSetting = <add key="RecordAuthorization" value=""/>
}

CurrentSetting = %FoundSetting%


FileRead, TheText, %SourceDir%\Website\Config\Ultimo.Web.Config
StringReplace, NewText, TheText, %CurrentSetting%, %NewSetting%, All 
FileDelete, %SourceDir%\Website\Config\Ultimo.Web.Config
FileAppend, %NewText%, %SourceDir%\Website\Config\Ultimo.Web.Config

MsgBox Record Authorization changed to `n%NewSetting%`nReset environment. 
ButtonClose:
ExitApp

Sub2:
MsgBox, Bye.
ExitApp