# Settings
$password = "Qwerty7" | ConvertTo-SecureString -asPlainText -Force
$username = "ad\administrator" 
$cred = New-Object System.Management.Automation.PSCredential($username,$password)
$TempFolder = "C:\DSC\Temp"
$DomainName = "ad.example.com"
$MediaShare = "\\192.168.110.2\Media$"
$DefaultGateway = "192.168.110.1"
$DNSServers = "192.168.110.11" ,"192.168.110.12"