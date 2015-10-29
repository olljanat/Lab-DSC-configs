param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][string]$DomainName,
	[Parameter(Mandatory)][pscredential]$cred,
	[Parameter(Mandatory)][string]$OutputPath
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName="DomainController";
            PSDscAllowPlainTextPassword=$true;
			PSDscAllowDomainUser = $true;
         }
	)
}

Configuration DomainController
{
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		 [Parameter(Mandatory)][string]$DomainName,
         [Parameter(Mandatory)][pscredential]$safemodeCred, 
         [Parameter(Mandatory)][pscredential]$domainCred
	)
    Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xActiveDirectory,xOU
    Node $RoleName {
        WindowsFeature ADDSInstall {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
        }

        xADDomain FirstDC {
            DomainName = $DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeCred
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

		# OU structure
		xADOrganizationalUnit Example {
			Name = "Example"
			Path = "DC=ad,DC=example,DC=com"
			Ensure = "Present"
			Credential = $domainCred
			Description = "Example"
		}
		xADOrganizationalUnit Servers {
			Name = "Servers"
			Path = "OU=Example,DC=ad,DC=example,DC=com"
			Ensure = "Present"
			DependsOn = '[xADOrganizationalUnit]Example'
			Credential = $domainCred
			# Description = "Servers"
		}
		xADOrganizationalUnit Users {
			Name = "Users"
			Path = "OU=Example,DC=ad,DC=example,DC=com"
			Ensure = "Present"
			DependsOn = '[xADOrganizationalUnit]Example'
			Credential = $domainCred
			Description = "Users"
		}
		xADOrganizationalUnit ServiceAccounts {
			Name = "ServiceAccounts"
			Path = "OU=Example,DC=ad,DC=example,DC=com"
			Ensure = "Present"
			DependsOn = '[xADOrganizationalUnit]Example'
			Credential = $domainCred
			Description = "Service Accounts"
		}
		xADOrganizationalUnit Groups {
			Name = "Groups"
			Path = "OU=Example,DC=ad,DC=example,DC=com"
			Ensure = "Present"
			DependsOn = '[xADOrganizationalUnit]Example'
			Credential = $domainCred
			Description = "Groups"
		}
		
		# Test users
		xADUser Olli {
			UserName = "olli"
			DomainName = $DomainName
			Password = $domainCred
			DomainAdministratorCredential = $domainCred
		}
		
    }
}
DomainController -RoleName "DomainController" -OutputPath $TempFolder -DomainName $DomainName -domainCred $cred -safemodeCred $cred -ConfigurationData $ConfigData