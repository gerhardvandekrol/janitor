#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;define the naming of the scripts
sc110 = 110_DatabaseRights_mssql.sql
sc120 = 120_RebuildIndexes_mssql.sql
sc130 = 130_1000_Rep_mssql.sql
sc140 = 140_1000_Chk_MsSql.sql
sc150 = 150_1000_mssql.sql
sc160 = 160_1000_Rep_MsSql.sql
sc170 = 170_1000_Chk_MsSql.sql
sc180 = 180_DatabaseShrink_mssql.sql

EnviDir = C:\Environments
EnviDir=%1%

;IfNotExist, C:\Environments
;    EnviDir = ::{20d04fe0-3aea-1069-a2d8-08002b30309d} ; My Computer

;MsgBox, Error - Use with caution. %WhichFolder%\%sc50% may not get refreshed.

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
 if ErrorLevel  ; i.e. it's not blank or zero.
    GoSub, Sub2	

MsgBox, 4, , We are going to copy the new update files from version %version% to %WhichFolder% and delete the current files`n`n%sc110%`n%sc120%`n%sc130%`n%sc140%`n%sc150%`n%sc160%`n%sc170%`n%sc180%`n`nWould you like to continue?, 15  ; 15-second timeout.
IfMsgBox, No
    Return  ; User pressed the "No" button.
IfMsgBox, Timeout
    Return ; i.e. Assume "No" if it timed out.
; Otherwise, continue:

FileDelete, %WhichFolder%\%sc110%
FileDelete, %WhichFolder%\%sc120%
FileDelete, %WhichFolder%\%sc130%
FileDelete, %WhichFolder%\%sc140%
FileDelete, %WhichFolder%\%sc150%
FileDelete, %WhichFolder%\%sc160%
FileDelete, %WhichFolder%\%sc170%
FileDelete, %WhichFolder%\%sc180%
MsgBox, File are deleted. Maybe %sc150% needs to be deleted manually.
FileCopy, P:\U10\%Version%\Data\DatabaseRights_mssql.sql, %WhichFolder%\%sc110%,1
FileCopy, P:\U10\%Version%\Data\RebuildIndexes_mssql.sql, %WhichFolder%\%sc120%,1
FileCopy, P:\U10\%Version%\Data\1000_Rep_mssql.sql, %WhichFolder%\%sc130%,1
FileCopy, P:\U10\%Version%\Data\1000_Chk_MsSql.sql, %WhichFolder%\%sc140%,1
FileCopy, P:\U10\%Version%\Data\1000_mssql.sql, %WhichFolder%\%sc150%,1
FileCopy, P:\U10\%Version%\Data\1000_Rep_MsSql.sql, %WhichFolder%\%sc160%,1
FileCopy, P:\U10\%Version%\Data\1000_Chk_MsSql.sql, %WhichFolder%\%sc170%,1
FileCopy, P:\U10\%Version%\Data\DatabaseShrink_mssql.sql, %WhichFolder%\%sc180%,1

MsgBox Updatescripts for version %Version% have been copied to %WhichFolder%. Thank you for using this awesome tool. Enjoy your day!
Exit

Sub2:
MsgBox, Bye.
Exit