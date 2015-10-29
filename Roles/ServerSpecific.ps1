param
(
	[Parameter(Mandatory)][string]$MachineName,
	[Parameter(Mandatory)][string]$IPAddress,
	[Parameter(Mandatory)][string]$OutputPath
)
configuration $MachineName
{
    param
    (
        [Parameter(Mandatory)][string]$MachineName,
		[Parameter(Mandatory)][string]$IPAddress,
		[int]$SubnetMask = 24,
        [string]$DefaultGateway = "192.168.110.1",
        [string]$InterfaceAlias = "Ethernet",
        [ValidateSet("IPv4","IPv6")][string]$AddressFamily = 'IPv4'
    )

    Import-DscResource -Module xNetworking

    Node $MachineName
    {
        xIPAddress NewIPAddress
        {
            IPAddress      = $IPAddress
            InterfaceAlias = $InterfaceAlias
            SubnetMask     = $SubnetMask
            AddressFamily  = $AddressFamily
        }
		
        xDefaultGatewayAddress SetDefaultGateway
        {
            Address        = $DefaultGateway
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = $AddressFamily
        }
    }
}
& $MachineName -MachineName $MachineName -IPAddress $IPAddress -OutputPath $OutputPath



