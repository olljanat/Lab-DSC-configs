param(	[Parameter(Mandatory)][string]$ConfigurationID,	[Parameter(Mandatory)][string]$PullServerURL,	[Parameter(Mandatory)][string]$RegistrationKey,
	[Parameter(Mandatory)][string]$ServerName)[DSCLocalConfigurationManager()]configuration PartialConfig{	param	(		[Parameter(Mandatory)][string]$ConfigurationID,		[Parameter(Mandatory)][string]$PullServerURL,		[Parameter(Mandatory)][string]$RegistrationKey,
		[Parameter(Mandatory)][string]$ServerName			)    Node localhost    {        Settings        {            RefreshFrequencyMins = 30;            RefreshMode = "PULL";            ConfigurationMode = 'ApplyAndAutocorrect';            AllowModuleOverwrite  = $true;            RebootNodeIfNeeded = $true;            ConfigurationModeFrequencyMins = 15;			ConfigurationID = $ConfigurationID        }        ConfigurationRepositoryWeb PullSrv        {            ServerURL = $PullServerURL            RegistrationKey = $RegistrationKey			AllowUnsecureConnection = $True        }
		PartialConfiguration $ServerName
        {
            Description = 'Server specific configuration'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'
            RefreshMode = 'Pull'
        }		PartialConfiguration MemberServer        {            Description = 'Configuration for the domain member servers'            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'            RefreshMode = 'Pull'        }		PartialConfiguration SQLServer        {            Description = 'Configuration for the SQL Server'            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'            DependsOn = "[PartialConfiguration]MemberServer"            RefreshMode = 'Pull'        }    }}PartialConfig -ConfigurationID $ConfigurationID -PullServerURL $PullServerURL -RegistrationKey $RegistrationKey -ServerName $ServerNameSet-DSCLocalConfigurationManager -Path ./PartialConfig -Verbose