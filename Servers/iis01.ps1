# Generate configurations for IIS01
$Guid = "203fbfd0-e7cc-4c60-8ffc-c5b6b635cdd8"

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Include\Include.ps1"


# WinSrv role
& "$ScriptPath\..\Roles\WinSrv.ps1" -RoleName "WinSrv" -OutputPath $TempFolder -cred $cred
Publish-Config -RoleName "WinSrv" -Guid $Guid -TempFolder $TempFolder


# Web Server role
& "$ScriptPath\..\Roles\WebServer.ps1" -RoleName "WebServer" -OutputPath $TempFolder -cred $cred
Publish-Config -RoleName "WebServer" -Guid $Guid -TempFolder $TempFolder
