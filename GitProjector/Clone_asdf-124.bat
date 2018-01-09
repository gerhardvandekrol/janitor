:: ------------------------------------------------------------
:: Stap 1 - De gebruiker wordt om verschillende input gevraagd
:: ------------------------------------------------------------
setlocal

			SET customer=
			> UserMessage.vbs ECHO WScript.Echo InputBox("Wat is de naam van de klant?", "Klant", "asdf")
			FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET customer=%%A
			IF "%customer%"=="" EXIT /B
													DEL UserMessage.vbs  ELSE (
						SET ordernumber=
							> UserMessage.vbs ECHO WScript.Echo InputBox("Wat is het odprachtnummer?", "Opdracht#", "124")
							FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET ordernumber=%%A
							IF "%ordernumber%"==""	EXIT /B
																			DEL UserMessage.vbs  ELSE (
										SET version=
										> UserMessage.vbs ECHO WScript.Echo InputBox("Naar welke versie ga je updaten?", "Versie", "17.10.15")
										FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET version=%%A
										IF "%version%"==""	EXIT /B 
																				DEL UserMessage.vbs  ELSE (
																		SET version2017R2=
														> UserMessage.vbs ECHO WScript.Echo InputBox("Naar welke 2017R2 (17.04) versie ga je (als tussenstap) updaten?", "Versie", "17.04.12")
														FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET version_2017R2=%%A
														IF "%version_2017R2%"==""	EXIT /B 
																								DEL UserMessage.vbs  ELSE (
																		SET backupname=
																		> UserMessage.vbs ECHO WScript.Echo InputBox("Wat is de naam van het backup bestand (exclusief .bak)?", "Backupname", "asdfa")
																		FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET backupname=%%A
																		IF "%backupname%"=="" EXIT /B
																													DEL UserMessage.vbs ELSE ( 
																							SET sqlversion=
																							> UserMessage.vbs ECHO WScript.Echo InputBox("Wat is de SQL versie van de huidige database?", "Sql versie", "2016")
																							FOR /F "tokens=*" %%A IN ('CSCRIPT.EXE //NoLogo UserMessage.vbs') DO SET sqlversion=%%A
																							IF "%sqlversion%"=="" EXIT /B
																																		DEL UserMessage.vbs ELSE ( 

																								
																								
:: ------------------------------------------------------------
:: Stap 2	-	Door het systeem wordt gekeken of er sprake is van de 32 of 64 bits variant om te bepalen welke executable gebruikt moet worden
:: ------------------------------------------------------------
IF exist "C:\Program Files\Git\bin\git.exe" (
      set GIT_PATH="C:\Program Files\Git\bin\git.exe"
) ELSE (
      set GIT_PATH="C:\Program Files (x86)\Git\bin\git.exe"
)
C:
CD C:\Program Files (x86)\GitExtensions\PuTTY
pageant.exe C:\Users\gvandekrol\Documents\sshkey.ppk



:: ------------------------------------------------------------
:: Stap 3	-	Er wordt een clone gemaakt van de branch. De branch wordt bepaald op basis van de opgegeven doelversie
:: ------------------------------------------------------------
%GIT_PATH% clone -b SutDefaults git@gitlab.ishbv.nl:css/customer-projects-2.git C:\Environments\%customer%-%ordernumber%
if %ERRORLEVEL% GEQ 1 exit /B
pause

C:
CD "C:\Environments\%customer%-%ordernumber%\Scripts"
pause
%GIT_PATH% checkout -b "develop/%customer%-%ordernumber%"
if %ERRORLEVEL% GEQ 1 exit /B



:: ------------------------------------------------------------
:: Stap 4	-	Er worden een aantal standaard mappen en bestanden aangemaakt
:: ------------------------------------------------------------
MD "\\nasultimo01.ishbv.nl\Customer Projects Builds\%customer%-%ordernumber%"
CD "C:\Environments\%customer%-%ordernumber%\Scripts"
Rename "10_Update_U_XX.XX.XX" "10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%"
Rename "20_Update_U_XX.XX.XX" "20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%"
MD "C:\Environments\%customer%-%ordernumber%\FileServiceData\License"
MD "C:\Environments\%customer%-%ordernumber%\Documents"
CD "C:\Environments\%customer%-%ordernumber%\Documents"
COPY "\\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\UCTcertificate\Certificates.XML" "C:\Environments\%customer%-%ordernumber%\FileServiceData\License"
COPY "\\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\ITA-lijst\ITA-Lijst.xlsx" "C:\Environments\%customer%-%ordernumber%\Documents\ITA-Lijst_%customer%-%ordernumber%.xlsx"
COPY "\\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\SUT Checklist\SUT-Checklist.xlsx" "C:\Environments\%customer%-%ordernumber%\Documents\SUT-Checklist_%customer%-%ordernumber%.xlsx"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('C:\Environments\%customer%-%ordernumber%\%customer%-%ordernumber% - Snelkoppeling.lnk');$s.TargetPath='\\nasultimo01.ishbv.nl\Customer Projects Builds\%customer%-%ordernumber%';$s.Save()"



:: ------------------------------------------------------------
:: Stap 5	-	De scripts bestanden worden in vaste volgorde gekopieërd
:: ------------------------------------------------------------
:: Als eerste de 17.04 scripts
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\DatabaseRights_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\10_DatabaseRights_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\RebuildIndexes_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\20_RebuildIndexes_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\1000_Rep_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\30_1000_Rep_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\1000_Chk_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\40_1000_Chk_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\1000_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\50_1000_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\1000_Rep_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\60_1000_Rep_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\1000_Chk_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\70_1000_Chk_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\Data\DatabaseShrink_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\10_Update_U_%version_2017R2:~0,2%.%version_2017R2:~3,2%.%version_2017R2:~6,2%\10_Database\80_DatabaseShrink_mssql.sql"
:: Als tweede de 17.10 scripts
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_DatabaseRights_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\10_1700_DatabaseRights_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\RebuildIndexes_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\20_RebuildIndexes_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_Rep_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\30_1700_Rep_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_Chk_MsSql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\40_1700_Chk_MsSql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\50_1700_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_Rep_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\60_1700_Rep_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_Chk_MsSql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\70_1700_Chk_MsSql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\1700_SetColumnOrder_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\80_1700_SetColumnOrder_mssql.sql"
COPY "\\vmfile01.ishbv.nl\Builds\U10\%version:~0,2%.%version:~3,2%.%version:~6,2%\Data\DatabaseShrink_mssql.sql" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\10_Database\90_DatabaseShrink_mssql.sql"



:: ------------------------------------------------------------
:: Stap 6	-	Versie nummers worden geplaatst
:: ------------------------------------------------------------
call :FindReplace "[Klantnaam]" "%customer%" "C:\Environments\%customer%-%ordernumber%\Scripts\settings.xml"
call :FindReplace "[Opdrachtnummer]" "%ordernumber%" "C:\Environments\%customer%-%ordernumber%\Scripts\settings.xml"
call :FindReplace "[SqlVersie]" "%sqlversion%" "C:\Environments\%customer%-%ordernumber%\Scripts\settings.xml"
call :FindReplace "[Klantdatabase]" "%backupname%" "C:\Environments\%customer%-%ordernumber%\Scripts\settings.xml"
call :FindReplace "[versie]" "%version:~0,2%.%version:~3,2%.%version:~6,2%" "C:\Environments\%customer%-%ordernumber%\Scripts\95_Finalize\30_Run_EventLog_DeleteOldItems.command"
call :FindReplace "[versie]" "%version:~0,2%.%version:~3,2%.%version:~6,2%" "C:\Environments\%customer%-%ordernumber%\Scripts\95_Finalize\90_RunApplicationValidator.command"
call :FindReplace "[versie]" "%version:~0,2%.%version:~3,2%.%version:~6,2%" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\20_Application\30_FixNews.command"
call :FindReplace "[versie]" "%version:~0,2%.%version:~3,2%.%version:~6,2%" "C:\Environments\%customer%-%ordernumber%\Scripts\20_Update_U_%version:~0,2%.%version:~3,2%.%version:~6,2%\20_Application\42_Cost_RegenerateCosts.command"



:: ------------------------------------------------------------
:: Stap 7	-	Fix encodings
:: ------------------------------------------------------------
C:\Environments\%customer%-%ordernumber%\Scripts\fix_encodings.bat



:FindReplace <findstr> <replstr> <file>
set tmp="%temp%\tmp.txt"
If not exist %temp%\_.vbs call :MakeReplace
for /f "tokens=*" %%a in ('dir "%3" /s /b /a-d /on') do (
  for /f "usebackq" %%b in (`Findstr /mic:"%~1" "%%a"`) do (
    echo(&Echo Replacing "%~1" with "%~2" in file %%~nxa
    <%%a cscript //nologo %temp%\_.vbs "%~1" "%~2">%tmp%
    if exist %tmp% move /Y %tmp% "%%~dpnxa">nul
  )
)
del %temp%\_.vbs
exit /b

:MakeReplace
>%temp%\_.vbs echo with Wscript
>>%temp%\_.vbs echo set args=.arguments
>>%temp%\_.vbs echo .StdOut.Write _
>>%temp%\_.vbs echo Replace(.StdIn.ReadAll,args(0),args(1),1,-1,1)
>>%temp%\_.vbs echo end with


REM :: ------------------------------------------------------------
REM :: Stap 8	-	De "Initial project setup" wordt gepushed
REM :: ------------------------------------------------------------
REM %GIT_PATH% add -A
REM %GIT_PATH% commit -m "Initial project setup" .
REM %GIT_PATH% push --set-upstream origin "develop/%customer%-%ordernumber%"
REM EXIT /B