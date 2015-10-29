# Generate configurations for IIS01
$Guid = "8a9fdae1-1699-421c-ac3e-36ce8c12a572"

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Include\Include.ps1"


# MemberServer role
& "$ScriptPath\..\Roles\MemberServer.ps1" -RoleName "MemberServer" -OutputPath $TempFolder -MachineName "sql01" -Domain $DomainName -Credential $cred
Publish-Config -RoleName "MemberServer" -Guid $Guid -TempFolder $TempFolder


# SQL Server role
# & "$ScriptPath\..\Roles\SQLServer.ps1" -RoleName "SQLServer" -OutputPath $TempFolder -cred $cred
# Publish-Config -RoleName "SQLServer" -Guid $Guid -TempFolder $TempFolder
