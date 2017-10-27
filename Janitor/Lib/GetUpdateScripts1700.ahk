#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;define the naming of the scripts
sc210 = 210_1700_DatabaseRights_mssql.sql
sc220 = 220_1700_RebuildIndexes_mssql.sql
sc230 = 230_1700_Rep_mssql.sql
sc240 = 240_1700_Chk_MsSql.sql
sc250 = 250_1700_mssql.sql
sc260 = 260_1700_Rep_MsSql.sql
sc270 = 270_1700_Chk_MsSql.sql
sc280 = 280_SetColumnOrder_mssql.sql
sc290 = 290_DatabaseShrink_mssql.sql

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

MsgBox, 4, , We are going to copy the new update files from version %version% to %WhichFolder% and delete the current files`n`n%sc210%`n%sc220%`n%sc230%`n%sc240%`n%sc250%`n%sc260%`n%sc270%`n%sc280%`n`nWould you like to continue?, 15  ; 15-second timeout.
IfMsgBox, No
    Return  ; User pressed the "No" button.
IfMsgBox, Timeout
    Return ; i.e. Assume "No" if it timed out.
; Otherwise, continue:

FileDelete, %WhichFolder%\%sc210%
FileDelete, %WhichFolder%\%sc220%
FileDelete, %WhichFolder%\%sc230%
FileDelete, %WhichFolder%\%sc240%
FileDelete, %WhichFolder%\%sc250%
FileDelete, %WhichFolder%\%sc260%
FileDelete, %WhichFolder%\%sc270%
FileDelete, %WhichFolder%\%sc280%
FileDelete, %WhichFolder%\%sc290%

MsgBox, File are deleted. Maybe %sc250% needs to be deleted manually.
FileCopy, P:\U10\%Version%\Data\1700_DatabaseRights_mssql.sql, %WhichFolder%\%sc210%,1
FileCopy, P:\U10\%Version%\Data\RebuildIndexes_mssql.sql, %WhichFolder%\%sc220%,1
FileCopy, P:\U10\%Version%\Data\1700_Rep_mssql.sql, %WhichFolder%\%sc230%,1
FileCopy, P:\U10\%Version%\Data\1700_Chk_MsSql.sql, %WhichFolder%\%sc240%,1
FileCopy, P:\U10\%Version%\Data\1700_mssql.sql, %WhichFolder%\%sc250%,1
FileCopy, P:\U10\%Version%\Data\1700_Rep_MsSql.sql, %WhichFolder%\%sc260%,1
FileCopy, P:\U10\%Version%\Data\1700_Chk_MsSql.sql, %WhichFolder%\%sc270%,1
FileCopy, P:\U10\%Version%\Data\1700_SetColumnOrder_mssql.sql, %WhichFolder%\%sc280%,1
FileCopy, P:\U10\%Version%\Data\DatabaseShrink_mssql.sql, %WhichFolder%\%sc290%,1

MsgBox Updatescripts for version %Version% have been copied to %WhichFolder%. Thank you for using this awesome tool. Enjoy your day!
Exit

Sub2:
MsgBox, Bye.
Exit