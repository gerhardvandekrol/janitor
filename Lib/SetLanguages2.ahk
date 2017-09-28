#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SourceDir= %1%

;EnviDir = C:\Environments
;IfNotExist, C:\Environments
;    EnviDir = ::{20d04fe0-3aea-1069-a2d8-08002b30309d} ; My Computer

;FileSelectFolder, SourceDir,%EnviDir%,0,Select environment to change the Installed Languagepack.
 ;if ErrorLevel  ; when you click on cancel
 ;   GoSub, Sub2	
;else

FileReadLine,FoundSetting, %SourceDir%\Website\Config\Ultimo.Config,7

Gui, New
Gui, Add, Picture, x0 y0 h99 w500, ultimo_SUT_wide.png
Gui, Add, Text,x30 y100 w500 h20, You selected %SourceDir%  %passeddir%
Gui, Add, Text,x30 y120 w500 h20, Found language setting %FoundSetting%
Gui, Add, Radio, Checked vSetLangTo, Set language to <InstalledLanguagePacks Value="NL" />
Gui, Add, Radio, , Set language to <InstalledLanguagePacks Value="EN" />
Gui, Add, Radio, , Set language to <InstalledLanguagePacks Value="DE" />
Gui, Add, Radio, , Set language to <InstalledLanguagePacks Value="NL,EN" />

Gui, Add, Button, x410 y230 w60 h20 default, Close  ; The label ButtonClose (if it exists) will be run when the button is pressed.
Gui, Add, Button, x345 y230 w50 h20 default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.


Gui, Show, AutoSize Center, SUT Supertools LanguageSwitcher
return

ButtonOK:
Gui, Submit
;MsgBox %SetLangTo% 

if (SetLangTo = 1) { 
NewSetting = <InstalledLanguagePacks Value="NL" />
}
else if (SetLangTo = 2) { 
NewSetting = <InstalledLanguagePacks Value="EN" />
}
else if (SetLangTo = 3) { 
NewSetting = <InstalledLanguagePacks Value="DE" />
}
else if (SetLangTo = 4) { 
NewSetting = <InstalledLanguagePacks Value="NL,EN" />
}
Else {
NewSetting = <InstalledLanguagePacks Value="NL,EN,DE,FR,PL" />
}

;CurrentSetting = <InstalledLanguagePacks Value="NL,EN,DE,FR,PL" />
CurrentSetting = %FoundSetting%


FileRead, TheText, %SourceDir%\Website\Config\Ultimo.Config
StringReplace, NewText, TheText, %CurrentSetting%, %NewSetting%, All 
FileDelete, %SourceDir%\Website\Config\Ultimo.Config
FileAppend, %NewText%, %SourceDir%\Website\Config\Ultimo.Config

FileRead, TheText, %SourceDir%\Services\ServiceHost\Config\Ultimo.Config
StringReplace, NewText, TheText, %CurrentSetting%, %NewSetting%, All 
FileDelete, %SourceDir%\Services\ServiceHost\Config\Ultimo.Config
FileAppend, %NewText%, %SourceDir%\Services\ServiceHost\Config\Ultimo.Config

FileRead, TheText, %SourceDir%\Services\CadService\Config\Ultimo.Config
StringReplace, NewText, TheText, %CurrentSetting%, %NewSetting%, All 
FileDelete, %SourceDir%\Services\CadService\Config\Ultimo.Config
FileAppend, %NewText%, %SourceDir%\Services\CadService\Config\Ultimo.Config

FileRead, TheText, %SourceDir%\Services\Tools\Config\Ultimo.Config
StringReplace, NewText, TheText, %CurrentSetting%, %NewSetting%, All 
FileDelete, %SourceDir%\Services\Tools\Config\Ultimo.Config
FileAppend, %NewText%, %SourceDir%\Services\Tools\Config\Ultimo.Config

MsgBox Language changed to %NewSetting% `n This nifty tool just saved you 2 minutes. Take a break!
ButtonClose:
ExitApp

Sub2:
MsgBox, Bye.
ExitApp