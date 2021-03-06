######################
# Title: CheckApplicationLogforErrors.ps1
# Author: Jwingram
# Date: 11/02/15
# Description: Checks the Windows Application Event logs for errors
######################

$emailFrom = "FROM EMAIL ADDRESS"
$emailTo = "TO EMAIL ADDRESS"
$subject = "Application Error"
$smtpServer = "SMTP SERVER"
$apptocheck = "ENTER APP.EXE"
$sname=$myInvocation.MyCommand.Definition

#Check to see if there are errors in the Application Log in the last 30 minutes
$lastRunTime=get-date
$lastRunTime=$lastRunTime.addminutes(-30)
$errorMessage=Get-WinEvent -FilterHashtable @{Logname="Application"; ProviderName="Application Error"; Data=$apptocheck; StartTime=$lastRunTime} -erroraction 'silentlycontinue'
if($errormessage -ne $null)
{
  $events="Error Time: " + $errormessage.TimeCreated + "<br>ProviderName: " + $errormessage.providername + "<br>ID: " + $errormessage.Id + "<br>Message: " +$errormessage.message
}

#if either error was "caught" send email message
if ($events -ne $null)
{
  $body+= "There is a new error that needs attention.<font color=red><br><br>"
  $body+= $events
  $body+="<font color=black><br><br><p style=`"font-size:x-small;`">*****************************<br>This is an automated script located at $sname running on $env:computername as $env:username"  
  
  send-mailmessage -to $emailTo -from $emailFrom -subject $subject -smtpserver $smtpServer -body $body -bodyashtml
}