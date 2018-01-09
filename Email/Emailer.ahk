#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; OrderNumber=

OrderId=014439
ConnectString=Vmwinside02\sql2014



InputBox, OrderId, Order number, Enter order number,,300,150,820,320,,,%OrderId%
if ErrorLevel
    Return

FileRead, TheTemplateFile, %A_ScriptDir%\QueryTemplateForOrder.sql
StringReplace, ThePopulatedFile, TheTemplateFile, OrderNumber, %OrderId%,All 
FileDelete, %A_ScriptDir%\QueryForOrder.sql
FileAppend,%ThePopulatedFile%, %A_ScriptDir%\QueryForOrder.sql

;Runwait sqlcmd -S GKLE5570\SQL2014 -U sa -P s  -d Outside_Power  -i "%A_ScriptDir%\QueryForOrder.sql"  -o  "%A_ScriptDir%\Result.txt"

Runwait sqlcmd -S %ConnectString% -U UltimoRead -P EmERPlAn  -d UltimoInside-Acceptance  -i "%A_ScriptDir%\QueryForOrder.sql" -o "%A_ScriptDir%\Result.txt"

FileReadLine,Customer,%A_ScriptDir%\Result.txt,1
FileReadLine,CustomerId,%A_ScriptDir%\Result.txt,2
FileReadLine,OrderDesc,%A_ScriptDir%\Result.txt,3
FileReadLine,OrderProjectLead,%A_ScriptDir%\Result.txt,4
FileReadLine,SoftwarePakket,%A_ScriptDir%\Result.txt,5
FileReadLine,OrderHours,%A_ScriptDir%\Result.txt,6
FileReadLine,OrderProjectLeadEmail,%A_ScriptDir%\Result.txt,7

  

Gui, New
Gui Add, GroupBox, x10 y20 w480 h120 , Order settings
Gui, Add, Text, x30 y40 w100 h20 , Customer
Gui, Add, Text, x110 y40 w300 h20 ,: %CustomerId%
Gui, Add, Text, x180 y40 w300 h20 , %Customer%

Gui, Add, Text, x30 y60 w100 h20 , Order
Gui, Add, Text, x110 y60 w300 h20 ,: %OrderId%
Gui, Add, Text, x180 y60 w300 h20 , %OrderDesc%

Gui, Add, Text, x30 y80 w100 h20 , ProjectLeader
Gui, Add, Text, x110 y80 w300 h20 ,: %OrderProjectLead%, (%OrderProjectLeadEmail%)

;Gui, Add, Text, x30 y80 w100 h20 , ProjectLeader
;Gui, Add, Text, x210 y80 w300 h20 ,: (%OrderProjectLeadEmail%)

Gui, Add, Text, x30 y100 w100 h20 , Order details
Gui, Add, Text, x110 y100 w300 h20 ,: %SoftwarePakket%
Gui, Add, Text, x180 y100 w300 h20 , %OrderHours% hours
;Gui, Add, Text, x220 y100 w300 h20 , Hours

Gui, Add, Button, gSendEmail x300 y155 w80 h20 , Email
Gui, Add, Button, gResetProject x400 y155 w80 h20 , Reset Order
Gui, Show, w500 h420, Order Janitor
return


SendEmail:
LChoice = Beste  %OrderProjectLead%,
 Oi = Opdracht #%OrderId% - %Customer%  %OrderDesc% is aan je toegekend
 Ci = %LChoice%<br> <br>Je bent zojuist als uitvoerend  projectleider toegekend aan opdracht <a href= https://inside.ultimo.com/ultimo.aspx#screen/7edc0728-b1b2-45c3-e1f7-f8d8d824a2dd?_ordid=%OrderId%>%OrderId% - %Customer%  %OrderDesc%</a>. Wil je ervoor zorgen dat voor het eind van de week de opdracht is ingepland en de klant is geïnformeerd over de planning van de uitvoer. De procedure hiervoor kun je terug vinden op de <a href= https://ultimo.atlassian.net/wiki/spaces/CSS/pages/104719625/SUT+Procedures>Knowledge Base</a> <br> <br>De <a href= "\\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\Email\2018\On-premise\01_Aanvang_Opdracht_Omgeving_opvragen.oft">email-template</a> die je kunt gebruiken voor aanvang opdracht kun je terugvinden in "\\vmfile02.ishbv.nl\Customer Support Services\SUT\_Templates & Documents\Email\2018\On-premise\"<br><br>Deze template is vernieuwd en zorgt ervoor dat we de omgeving al eerder in ons bezit krijgen. Let op: hierdoor moet je wat anders de dagen inplannen die je nodig hebt voor de lokale update.<br> <br>Voor opdrachten die we in 2018 gaan uitvoeren bevestigen we ook versie Ultimo 2018 ondanks dat in de originele opdracht melding wordt gemaakt van 2017 versies. <br> <br> Met vriendelijke groeten , <br> <br> <b> Gerhard van de Krol </b> <br> <i> (Team Leader Update Team) </i> <br>  <br> Ultimo Software Solutions bv | Waterweg 3 | 8071 RR Nunspeet  <br> T   +31 341 42 37 37 <br> E <a href= Gerhard.vandeKrol@Ultimo.com > Gerhard.vandeKrol@Ultimo.com </a> <br> I <a href= www.ultimo.com > www.ultimo.com </a>

 
Recipient := OrderProjectLeadEmail
Subject := Oi
Body := Ci
Recipient3 = Updates@ultimo.com

DocumentLocation = Z:\Menu\Email\NALivegang

;example of creating a MailItem and setting it's format to HTML
olMailItem := 0
MailItem := ComObjActive("Outlook.Application").CreateItem(olMailItem)
olFormatHTML := 2
MailItem.BodyFormat := olFormatHTML
MailItem.Subject := Subject
MailItem.HTMLBody := Body
Recipient := MailItem.Recipients.Add(Recipient)
Recipient.Type := 1 ; To: CC: = 2 BCC: = 3
MailItem.bcc := Recipient3
MailItem.Display
Return

ResetProject:
GoSub, Reload
return

ReLoad:
Run "%A_ScriptDir%\emailer.ahk"
return