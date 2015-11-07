#requires -Version 5
param
(
	[Parameter(Mandatory)][string]$RoleName,
	[Parameter(Mandatory)][string]$OutputPath,
	[Parameter(Mandatory)][string]$ClusterName,
	[Parameter(Mandatory)][string]$ClusterIPaddress,
	[Parameter(Mandatory)][PSCredential]$domainCred,
	[Parameter(Mandatory)][PSCredential]$PsDscRunAsCredential,
	[Parameter(Mandatory)][string]$MediaShare
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "SQLAlwaysOnCluster";
            PSDscAllowPlainTextPassword = $true;
			PSDscAllowDomainUser = $true;
			# #
			# SourcePath = "\\RD01\Installer"
            # DomainAdministratorCredential = $DomainAdministratorCredential
            # InstallerServiceAccount = $InstallerServiceAccount
            # LocalSystemAccount = $LocalSystemAccount
            # SQLServiceAccount = $SQLServiceAccount
            # AdminAccount = "CONTOSO\Administrator"
         }
	)
}

Configuration SQLAlwaysOnCluster {
    param
    (
        [Parameter(Mandatory)][string]$RoleName,
		[Parameter(Mandatory)][string]$ClusterName,
		[Parameter(Mandatory)][string]$ClusterIPaddress,
		[Parameter(Mandatory)][PSCredential]$domainCred,
		[Parameter(Mandatory)][PSCredential]$PsDscRunAsCredential,
		[Parameter(Mandatory)][string]$MediaShare
    )
	Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="1.1"},xFailoverCluster,xSQLServer,xActiveDirectory
	
    Node $RoleName {
        WindowsFeature "Failover-Clustering"
        {
            Ensure = "Present"
            Name = "Failover-Clustering"
        }

        WindowsFeature "RSAT-Clustering-PowerShell"
        {
            Ensure = "Present"
            Name = "RSAT-Clustering-PowerShell"
        }

		xADUser "svc_$ClusterName" {
			UserName = "svc_$ClusterName"
			DomainName = $DomainName
			Password = New-Object System.Management.Automation.PSCredential("Ignore",("1Qaz2Wsx3Edc!" | ConvertTo-SecureString -asPlainText -Force))
			DomainAdministratorCredential = $domainCred
		}

        File MediaFolder {
            Type = 'Directory'
            DestinationPath = 'C:\Media'
            Ensure = "Present"
        }
				
        File CopySQL2014Media {
            Type = "Directory"
            DestinationPath = "C:\Media\SQL2014"
			Ensure = "Present"
			DependsOn = "[File]MediaFolder"
			
			## FixMe: File copying does not work for some reason...
            # SourcePath = "$MediaShare\SQL2014"
            # Recurse = $true
			# PsDscRunAsCredential = $PsDscRunAsCredential
        }
		
		xCluster $ClusterName
		{
			DependsOn = @(
				"[WindowsFeature]Failover-Clustering",
				"[WindowsFeature]RSAT-Clustering-PowerShell"
			)
			Name = $ClusterName
			StaticIPAddress = $ClusterIPaddress
			DomainAdministratorCredential = $domainCred
		}

        xSQLServerFailoverClusterSetup "PrepareMSSQLAlwaysOnCluster"
        {
            DependsOn = @(
                "[WindowsFeature]Failover-Clustering"
            )
            Action = "Prepare"
            SourcePath = "C:\Media\SQL2014"
            SetupCredential = $domainCred
			Features = "SQLENGINE,ADV_SSMS"
            InstanceName = "MSSQLSERVER"
            FailoverClusterNetworkName = $ClusterName
		    SQLSvcAccount = New-Object System.Management.Automation.PSCredential("AD\svc_$ClusterName",("1Qaz2Wsx3Edc!" | ConvertTo-SecureString -asPlainText -Force))
        }
    }
}
SQLAlwaysOnCluster -RoleName "SQLAlwaysOnCluster" -OutputPath $OutputPath -ConfigurationData $ConfigData -ClusterName $ClusterName -ClusterIPaddress $ClusterIPaddress -domainCred $domainCred -MediaShare $MediaShare -PsDscRunAsCredential $PsDscRunAsCredential