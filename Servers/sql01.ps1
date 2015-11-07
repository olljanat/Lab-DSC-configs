# Generate configurations for SQL01
$Guid = "8a9fdae1-1699-421c-ac3e-36ce8c12a572"
$MachineName = "sql01"
$IPAddress = "192.168.110.21"
$ClusterName = "SQLCLUSTER01"
$ClusterIPaddress  = "192.168.110.41"

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Include\Include.ps1"


# Server specific settings
& "$ScriptPath\..\Roles\ServerSpecific.ps1" -MachineName $MachineName -IPAddress $IPAddress -OutputPath $TempFolder -DefaultGateway $DefaultGateway -DNSServers $DNSServers
Publish-Config -RoleName $MachineName -Guid $Guid -TempFolder $TempFolder


# MemberServer role
& "$ScriptPath\..\Roles\MemberServer.ps1" -RoleName "MemberServer" -OutputPath $TempFolder -MachineName $MachineName -Domain $DomainName -Credential $cred
Publish-Config -RoleName "MemberServer" -Guid $Guid -TempFolder $TempFolder


# SQL Server role
& "$ScriptPath\..\Roles\SQLAlwaysOnCluster.ps1" -RoleName "SQLAlwaysOnCluster" -OutputPath $TempFolder -ClusterName $ClusterName -ClusterIPaddress $ClusterIPaddress -domainCred $cred -MediaShare $MediaShare -PsDscRunAsCredential $PsDscRunAsCredential
Publish-Config -RoleName "SQLAlwaysOnCluster" -Guid $Guid -TempFolder $TempFolder
