param
(
	[Parameter(Mandatory)][string]$MachineName,
	[Parameter(Mandatory)][string]$IPAddress,
	[Parameter(Mandatory)][string]$DefaultGateway,
	[Parameter(Mandatory)][string[]]$DNSServers,
	[Parameter(Mandatory)][string]$OutputPath
)
configuration $MachineName
{
    param
    (
        [Parameter(Mandatory)][string]$MachineName,
		[Parameter(Mandatory)][string]$IPAddress,
		[int]$SubnetMask = 24,
        [Parameter(Mandatory)][string]$DefaultGateway,
        [string]$InterfaceAlias = "Ethernet",
        [ValidateSet("IPv4","IPv6")][string]$AddressFamily = 'IPv4',
		[Parameter(Mandatory)][string[]]$DNSServers
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
		
		xDNSServerAddress SetDNSsettings {
			Address = $DNSServers
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = $AddressFamily
		}
    }
}
& $MachineName -MachineName $MachineName -IPAddress $IPAddress -OutputPath $OutputPath -DefaultGateway $DefaultGateway -DNSServers $DNSServers



