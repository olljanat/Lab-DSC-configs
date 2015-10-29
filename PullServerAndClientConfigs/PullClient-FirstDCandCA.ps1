param
(
	[Parameter(Mandatory)][string]$ConfigurationID,
	[Parameter(Mandatory)][string]$ServerURL,
	[Parameter(Mandatory)][string]$RegistrationKey
)
[DSCLocalConfigurationManager()]
configuration PartialConfig
{
	param
	(
		[Parameter(Mandatory)][string]$ConfigurationID,
		[Parameter(Mandatory)][string]$ServerURL,
		[Parameter(Mandatory)][string]$RegistrationKey
	)
    Node localhost
    {
        Settings
        {
            RefreshFrequencyMins = 30;
            RefreshMode = "PULL";
            ConfigurationMode = 'ApplyAndAutocorrect';
            AllowModuleOverwrite  = $true;
            RebootNodeIfNeeded = $true;
            ConfigurationModeFrequencyMins = 15;
			ConfigurationID = $ConfigurationID
        }
        ConfigurationRepositoryWeb PullSrv
        {
            ServerURL = $ServerURL
            RegistrationKey = $RegistrationKey
			AllowUnsecureConnection = $True	
        }       
           PartialConfiguration WinSrv
        {
            Description = 'Configuration for the Base OS'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'
            RefreshMode = 'Pull'
        }
           PartialConfiguration DomainController
        {
            Description = 'Configuration for the Domain Controller'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'
            DependsOn = "[PartialConfiguration]WinSrv"
            RefreshMode = 'Pull'
        }
           PartialConfiguration CertificateAuthority
        {
            Description = 'Configuration for the Certificate Authority'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'
            DependsOn = "[PartialConfiguration]WinSrv"
            RefreshMode = 'Pull'
        }
    }
}
PartialConfig -Guid $ConfigurationID -ServerURL $ServerURL -RegistrationKey $RegistrationKey
Set-DSCLocalConfigurationManager -Path ./PartialConfig -Verbose