param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][string]$MachineName,
	[Parameter(Mandatory)][string]$Domain,
	[Parameter(Mandatory)][pscredential]$Credential,
	[Parameter(Mandatory)][string]$OutputPath
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "MemberServer";
            PSDscAllowPlainTextPassword = $true;
			PSDscAllowDomainUser = $true;
         }
	)
}

Configuration MemberServer
{
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][pscredential]$Credential,
        [Parameter(Mandatory)][string]$MachineName, 
        [Parameter(Mandatory)][string]$Domain
    )
	Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xComputerManagement,xSystemSecurity
    Node $RoleName {
        File LogsFolder {
            Type = 'Directory'
            DestinationPath = 'C:\Logs'
            Ensure = "Present"
        }

        xComputer JoinDomain 
        { 
            Name          = $MachineName  
            DomainName    = $Domain 
            Credential    = $Credential 
        } 		
		
		# Security settings
		xIEEsc DisableIEE {
			IsEnabled = $False
			UserRole = "Users"
		}
        xUAC NotifyChanges { 
            Setting = "NotifyChanges" 
        } 
    }
}

MemberServer -RoleName "MemberServer" -MachineName $MachineName -Domain $Domain -OutputPath $TempFolder -ConfigurationData $ConfigData -Credential $Credential