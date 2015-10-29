$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$PullServerURL = "http://192.168.110.2:8080/PSDSCPullServer.svc"
$RegistrationKey = "a9c539f9-63d2-460c-9f5f-ed10cc6dac79"


## dc01
#& "$ScriptPath\PullClient-FirstDCandCA.ps1" -ConfigurationID "1d545e3b-60c3-47a0-bf65-5afc05182fd0" -PullServerURL $PullServerURL -RegistrationKey $RegistrationKey -ServerName "dc01"

## iis01
#& "$ScriptPath\PullClient-WebServer.ps1" -ConfigurationID "203fbfd0-e7cc-4c60-8ffc-c5b6b635cdd8" -PullServerURL $PullServerURL -RegistrationKey $RegistrationKey -ServerName "iis01"

## sql01
#& "$ScriptPath\PullClient-SQLServer.ps1" -ConfigurationID "8a9fdae1-1699-421c-ac3e-36ce8c12a572" -PullServerURL $PullServerURL -RegistrationKey $RegistrationKey -ServerName "sql01"

