Function Publish-Config {
	param (
		[Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][string]$Guid,
		[Parameter(Mandatory)][string]$TempFolder
	)
	
	$source = "$TempFolder\$RoleName.mof"
	$dest = "C:\Program Files\WindowsPowerShell\DscService\Configuration\$RoleName.$Guid.mof"
	copy $source $dest
	New-DscChecksum $dest -Force
	Remove-Item $source -Force
}