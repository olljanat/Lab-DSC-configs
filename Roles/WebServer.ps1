param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][pscredential]$cred,
	[Parameter(Mandatory)][string]$OutputPath
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "WebServer";
            PSDscAllowPlainTextPassword = $true;
			PSDscAllowDomainUser = $true;
         }
	)
}

Configuration WebServer {
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][PSCredential]$PfxPassword = (Get-Credential -Message 'Enter PFX extraction password.' -UserName 'Ignore'),
		[Parameter(Mandatory)][PSCredential]$PsDscRunAsCredential
    )
	Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xCertificate,xWebAdministration
    Node $RoleName {	
        WindowsFeature Web-Mgmt-Tools {
            Ensure = 'Present'
            Name  = 'Web-Mgmt-Tools'
			IncludeAllSubFeature = $True
			LogPath = "C:\Logs\Web-Mgmt-Tools_install.log"
		}
			
        WindowsFeature Web-WebServer {
            Ensure = 'Present'
            Name  = 'Web-WebServer'
			IncludeAllSubFeature = $True
			LogPath = "C:\Logs\Web-WebServer_install.log"
        }
        WindowsFeature AspNet45 { 
            Ensure          = "Present" 
            Name            = "Web-Asp-Net45" 
			LogPath = "C:\Logs\AspNet45_install.log"
			DependsOn = "[WindowsFeature]Web-WebServer"
        } 
		
        xPfxImport StarCert {
            Thumbprint = '8DA02EAAA7311392AFF18DA58D495824F828D798'
            Path = '\\192.168.110.2\cert$\star_example_com.pfx'
            Store = 'My'
            Credential = $PfxPassword
			PsDscRunAsCredential = $PsDscRunAsCredential
            DependsOn = '[WindowsFeature]Web-WebServer'
        }

        xWebsite DefaultWebSite
        { 
            Ensure          = "Present" 
            Name            = "Default Web Site"
            State           = "Started" 
            PhysicalPath    = "C:\Inetpub\wwwroot" 
            BindingInfo     = @(
									@(MSFT_xWebBindingInformation 
									{ 
										Protocol              = "HTTPS" 
										Port                  = 443 
										CertificateThumbprint ="8DA02EAAA7311392AFF18DA58D495824F828D798" 
										CertificateStoreName  = "My" 
									});
									@(MSFT_xWebBindingInformation   
									{  
										Protocol              = "HTTP"
										Port                  =  80 
									})
								);
			 DependsOn = '[WindowsFeature]Web-WebServer','[xPfxImport]StarCert'
        } 

    }
}
WebServer -RoleName "WebServer" -OutputPath $TempFolder -PfxPassword $cred -PsDscRunAsCredential $cred -ConfigurationData $ConfigData