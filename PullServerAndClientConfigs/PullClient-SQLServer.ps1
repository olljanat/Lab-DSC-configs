param
	[Parameter(Mandatory)][string]$ServerName
		[Parameter(Mandatory)][string]$ServerName		
		PartialConfiguration $ServerName
        {
            Description = 'Server specific configuration'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullSrv'
            RefreshMode = 'Pull'
        }