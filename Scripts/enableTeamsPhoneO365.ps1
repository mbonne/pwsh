## Enabling Teams Phone calling - Notes file from KBs found online

Must use Azure PowerShell and then run -  Import-Module SkypeOnlineConnector
## the % symbol is shorthand for the 'for each' loop
Guide found here: https://support.switchconnect.com.au/portal/kb/articles/activating-users-for-direct-routing

Must use Azure PowerShell from within Windows 10 - and then run -  Import-Module SkypeOnlineConnector
before connecting to the Office365 tenancy with global admin account. PowerShell for Mac can use the required connectors yet

##===============================================================================================================##
## Provisioning: Configure SIP Trunk PowerShell Commands
Import-Module SkypeOnlineConnector

## Then connect to O365
$cred = Get-Credential
$session = New-CsOnlineSession -Credential $cred -verbose
Import-PSSession $session

## Enable Voice for User and assign Number
Set-CsUser -Identity user.1@company.com.au -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI tel:+61283311111

## Assign Voice Route to User
Grant-CsOnlineVoiceRoutingPolicy -Identity "user.1@company.com.au" -PolicyName Australia

## Verify all Settings are correct
Get-CsOnlineUser -Identity "user.1@company.com.au" | Format-List -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, dialplan, TeamsInteropPolicy

##===================================Examples below to illustrate bulk action====================================##

Import-Csv "C:\userList.csv" | %{Set-CsUser -Identity $_.Identity -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $_.OnPremLineURI}
##
Import-Csv "C:\userList.csv" | %{Grant-CsOnlineVoiceRoutingPolicy -Identity $_.Identity -PolicyName Australia}
##
Import-Csv "C:\userList.csv" | %{Get-CsOnlineUser -Identity $_.Identity | Format-List -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, dialplan, TeamsInteropPolicy}
##
## Or as a one liner (This is Importing .csv and applying the number to email account on the same row/line - Verify the settings as a second command when done)
Import-Csv "C:\userList.csv" | %{Set-CsUser -Identity $_.Identity -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $_.OnPremLineURI} | ForEach {Grant-CsOnlineVoiceRoutingPolicy -Identity $_.Identity -PolicyName Australia}
##
Import-Csv "C:\userList.csv" | %{Get-CsOnlineUser -Identity $_.Identity | Format-List -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, dialplan, TeamsInteropPolicy}
##

##===============================================================================================================##
SAMPLE CSV CONTENTS BELOW

Identity,OnPremLineURI
user.1@company.com.au,tel:+61283311111
user.2@company.com.au,tel:+61283322222
user@company.com.au,tel:+61283333333

A Note about using Variables in Powershell to reference columns in the .csv
When defining the Variable within the command you use the $_. before the column name as the variable. Make sure it is exactly the same as the column header.
Then foreach will iterate down the list of .csv rows to loop the command



##==================================================== scraps ====================================================##

Import-Csv "C:\userList.csv" | foreach {Set-CsUser -Identity $_.Identity -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $_.OnPremLineURI}

Import-Csv "C:\userList.csv" | foreach {Grant-CsOnlineVoiceRoutingPolicy -Identity $_.Identity -PolicyName Australia}

Import-Csv "C:\userList.csv" | foreach {Get-CsOnlineUser -Identity $_.Identity | Format-List -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, dialplan, TeamsInteropPolicy}

Import-Csv "C:\userList.csv" | foreach {Set-CsUser -Identity $_.Identity -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI $_.OnPremLineURI} | ForEach {Grant-CsOnlineVoiceRoutingPolicy -Identity $_.Identity -PolicyName Australia} | ForEach {Get-CsOnlineUser -Identity $_.Identity | Format-List -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, dialplan, TeamsInteropPolicy}


##===============================================================================================================##

