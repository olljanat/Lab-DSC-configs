[DSCLocalConfigurationManager()]
Configuration ResetClientConfig{
	Node localhost
	{		Settings		{			ConfigurationID = $null;			RefreshMode = "PUSH";			RebootNodeIfNeeded = $False;			RefreshFrequencyMins = 30;			ConfigurationModeFrequencyMins = 15;			ConfigurationMode = "ApplyAndMonitor";		}
	}} ResetClientConfig
Set-DSCLocalConfigurationManager -Path .\ResetClientConfig -Verbose