# Lab-DSC-configs
My plan is build whole my lab environment only using PowerShell DSC (Desired State Configuration) scripts.

I will upload all of them to here and hopefully they are useful for someone else too.


## Used modules:
* xActiveDirectory
* xOU (with bug fix which I have wrote here: https://gallery.technet.microsoft.com/xOU-PowerShell-Module-DSC-be133067/view/Discussions)
* xAdcsDeployment
* xSystemSecurity
* xCertificate (xPfxImport version from here: https://github.com/briantist/xCertificate/tree/xPfxImport)
* xWebAdministration
* [cADFS](https://github.com/pcgeek86/cADFS.git)
* xComputerManagement


## Found bugs during testing:
* [ConfigurationNames does not work with Partial configs](https://connect.microsoft.com/PowerShell/feedback/details/1944447)
* [DSC always applies all partial configs when changed only one](https://connect.microsoft.com/PowerShell/feedback/details/1951731)
* [xOU module: Bug on empty description handling](https://gallery.technet.microsoft.com/xOU-PowerShell-Module-DSC-be133067/view/Discussions)
* My workaround is described behind on link above.
* [Wrong  MSFT_RoleResource -version number on partial configuration](https://connect.microsoft.com/PowerShell/feedback/details/1768281/wmf-5-production-preview-partial-configuration-of-mof-file-generation-is-broken)
  * My workaround is described behind on link above.