# Generate configurations for IIS01
$Guid = "203fbfd0-e7cc-4c60-8ffc-c5b6b635cdd8"
$MachineName = "iis01"
$IPAddress = "192.168.110.31"

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Include\Include.ps1"

# Server specific settings
& "$ScriptPath\..\Roles\ServerSpecific.ps1" -MachineName $MachineName -IPAddress $IPAddress -OutputPath $TempFolder
Publish-Config -RoleName $MachineName -Guid $Guid -TempFolder $TempFolder

# MemberServer role
& "$ScriptPath\..\Roles\MemberServer.ps1" -RoleName "MemberServer" -OutputPath $TempFolder -MachineName $MachineName -Domain $DomainName -Credential $cred
Publish-Config -RoleName "MemberServer" -Guid $Guid -TempFolder $TempFolder


# Web Server role
& "$ScriptPath\..\Roles\WebServer.ps1" -RoleName "WebServer" -OutputPath $TempFolder -cred $cred
Publish-Config -RoleName "WebServer" -Guid $Guid -TempFolder $TempFolder
