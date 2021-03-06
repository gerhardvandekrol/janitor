﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;define the naming of the scripts
sc10 = 10_1700_DatabaseRights_mssql.sql
sc20 = 20_1700_RebuildIndexes_mssql.sql
sc30 = 30_1700_Rep_mssql.sql
sc40 = 40_1700_Chk_MsSql.sql
sc50 = 50_1700_mssql.sql
sc60 = 60_1700_Rep_MsSql.sql
sc70 = 70_1700_Chk_MsSql.sql
sc80 = 80_SetColumnOrder_mssql.sql
sc90 = 90_DatabaseShrink_mssql.sql

EnviDir = C:\Environments
EnviDir=%1%

;IfNotExist, C:\Environments
;    EnviDir = ::{20d04fe0-3aea-1069-a2d8-08002b30309d} ; My Computer

;MsgBox, Error - Use with caution. %WhichFolder%\%sc250% may not get refreshed.

MsgBox,4,Option, Select a folder in %EnviDir% ?
    IfMsgBox, Yes
        EnviDir=%1%
    IfMsgBox, No
        EnviDir = ::{20d04fe0-3aea-1069-a2d8-08002b30309d} ; My Computer

FileSelectFolder, WhichFolder,%EnviDir%,1,Select folder to update the scripts or create new entry.  ; Ask the user to pick or create a scriptfolder to update.
if ErrorLevel  ; i.e. it's not blank or zero.
    GoSub, Sub2	
else
InputBox,Version, Version, Enter the versionnumber in the format xx.xx.xx ;What is the version we should copy from the server.
checkfor17 := SubStr(Version,1,2)

 if checkfor17 < 17
 {
     MsgBox This is not for Ultimo 2018
     GoSub, Sub2
}	
 if ErrorLevel  ; i.e. it's not blank or zero.
    GoSub, Sub2	

MsgBox, 4, , We are going to copy the new update files from version %version% to %WhichFolder% and delete the current files`n`n%sc10%`n%sc20%`n%sc30%`n%sc40%`n%sc50%`n%sc60%`n%sc70%`n%sc80%`n`nWould you like to continue?, 15  ; 15-second timeout.
IfMsgBox, No
    Return  ; User pressed the "No" button.
IfMsgBox, Timeout
    Return ; i.e. Assume "No" if it timed out.
; Otherwise, continue:

FileDelete, %WhichFolder%\%sc10%
FileDelete, %WhichFolder%\%sc20%
FileDelete, %WhichFolder%\%sc30%
FileDelete, %WhichFolder%\%sc40%
FileDelete, %WhichFolder%\%sc50%
FileDelete, %WhichFolder%\%sc60%
FileDelete, %WhichFolder%\%sc70%
FileDelete, %WhichFolder%\%sc80%
FileDelete, %WhichFolder%\%sc90%

MsgBox, File are deleted. Maybe %sc250% needs to be deleted manually.
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_DatabaseRights_mssql.sql, %WhichFolder%\%sc10%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\RebuildIndexes_mssql.sql, %WhichFolder%\%sc20%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_Rep_mssql.sql, %WhichFolder%\%sc30%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_Chk_MsSql.sql, %WhichFolder%\%sc40%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_mssql.sql, %WhichFolder%\%sc50%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_Rep_MsSql.sql, %WhichFolder%\%sc60%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_Chk_MsSql.sql, %WhichFolder%\%sc70%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\1700_SetColumnOrder_mssql.sql, %WhichFolder%\%sc80%,1
FileCopy, \\vmfile01.ishbv.nl\Builds\U10\%Version%\Data\DatabaseShrink_mssql.sql, %WhichFolder%\%sc90%,1

MsgBox Updatescripts for version %Version% have been copied to %WhichFolder%. Thank you for using this awesome tool. Enjoy your day!
Exit

Sub2:
MsgBox, Bye.
Exit