$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$ScriptList = Get-ChildItem -Path "$ScriptPath\Servers\*.ps1"
ForEach ($script in $ScriptList) {
	& $script
}