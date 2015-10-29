# Generate configurations for DC01
$Guid = "1d545e3b-60c3-47a0-bf65-5afc05182fd0"

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Include\Include.ps1"

# DomainController role
& "$ScriptPath\..\Roles\FirstDomainController.ps1" -RoleName "DomainController" -OutputPath $TempFolder -DomainName "ad.example.com" -cred $cred
Publish-Config -RoleName "DomainController" -Guid $Guid -TempFolder $TempFolder


# CertificateAuthority role
& "$ScriptPath\..\Roles\CertificateAuthority.ps1" -RoleName "CertificateAuthority" -OutputPath $TempFolder -cred $cred
Publish-Config -RoleName "CertificateAuthority" -Guid $Guid -TempFolder $TempFolder
