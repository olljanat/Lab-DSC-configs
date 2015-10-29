param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][pscredential]$cred,
	[Parameter(Mandatory)][string]$OutputPath
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "WinSrv";
            PSDscAllowPlainTextPassword = $true;
			PSDscAllowDomainUser = $true;
         }
	)
}

Configuration WinSrv
{
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][pscredential]$cred
    )
	Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xSystemSecurity
    Node $RoleName {
        File LogsFolder {
            Type = 'Directory'
            DestinationPath = 'C:\Logs'
            Ensure = "Present"
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

WinSrv -RoleName "WinSrv" -OutputPath $TempFolder -ConfigurationData $ConfigData -cred $cred