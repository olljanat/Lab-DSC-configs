param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][pscredential]$cred,
	[Parameter(Mandatory)][string]$OutputPath
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "CertificateAuthority";
            PSDscAllowPlainTextPassword = $true;
			PSDscAllowDomainUser = $true;
         }
	)
}

Configuration CertificateAuthority {
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][pscredential]$cred
    )
	Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xAdcsDeployment
    Node $RoleName {
        WindowsFeature ADCS-Cert-Authority 
        { 
               Ensure = 'Present' 
               Name = 'ADCS-Cert-Authority' 
        } 
        xADCSCertificationAuthority RootCA { 
            Ensure = 'Present' 
            Credential = $cred 
            CAType = 'EnterpriseRootCA' 
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
			CACommonName = "Root CA"
			ValidityPeriod = "Years"
			ValidityPeriodUnits = 50
			HashAlgorithmName = "SHA256"
        }
        WindowsFeature RSAT-ADCS 
        { 
               Ensure = 'Present' 
               Name = 'RSAT-ADCS' 
        } 
    }
}
CertificateAuthority -RoleName "CertificateAuthority" -OutputPath $OutputPath -cred $cred -ConfigurationData $ConfigData