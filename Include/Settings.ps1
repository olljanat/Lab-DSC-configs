# Settings
$password = "Qwerty7" | ConvertTo-SecureString -asPlainText -Force
$username = "ad\administrator" 
$cred = New-Object System.Management.Automation.PSCredential($username,$password)
$TempFolder = "C:\DSC\Temp"
