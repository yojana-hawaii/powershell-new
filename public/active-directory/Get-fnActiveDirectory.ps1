function Get-fnActiveDirectoryInformation {
    [CmdletBinding()]
    param()

    $startTimer = Start-Timer

    $forest  = Get-fnForest
    $domain  = Get-fnDomain
    $rootDse = Get-fnRootDse

    $data = [ordered]@{}
    $data.Forest                    = $domain.Forest
    $data.Domain                    = $domain.DNSRoot
    $data.DomainFunctionality       = $rootDse.DomainFunctionality 
    $data.DomainControllerFunctionality = $rootDse.domainControllerFunctionality
    $data.DistinguishedName         = $domain.DistinguishedName

    $data.DomainController          = Get-fnDomainController
    $data.GlobalCatalog             = Get-fnGlobalCatalog
    $data.InfrastructureMaster      = $domain.InfrastructureMaster
    $data.SchemaMaster              = $forest.SchemaMaster
    $data.DomainNamingMaster        = $forest.DomainNamingMaster
    $data.PDCEmulator               = $domain.PDCEmulator
    $data.RIDMaster                 = $domain.RIDMaster
    $data.ReplicaDirectoryServers   = $domain.ReplicaDirectoryServers
    $data.ReadOnlyDC                = Get-fnRodc 
    $data.DomainControllerReplication= Get-fnDomainControllerReplication -Server $data.DomainController
    

    $data.rIDAvailablePool          = Get-fnDomainRids -DistinguishedName $data.DistinguishedName -RidMaster $data.RIDMaster
    $data.DnsSrv                    = (Get-fnDnsData -domain $data.Domain).SRV    
    $data.DnsA                      = (Get-fnDnsData -domain $data.Domain).A

    $data.DhcpServer                = Get-fnDhcpServer
    $data.DhcpServerOther           = "+ firewall + more???"
    $data.DnsServer                 = "Get-DnsClientServerAddress needs interfaceAlias ???"
    $data.ComputersContainer        = $domain.ComputersContainer
    $data.DeletedObjectsContainer   = $domain.DeletedObjectsContainer
    $data.DomainControllersContainer= $domain.DomainControllersContainer
    $data.ForeignSecurityPrincipalsContainer = $domain.ForeignSecurityPrincipalsContainer
    $data.LostAndFoundContainer     = $domain.LostAndFoundContainer
    $data.QuotasContainer           = $domain.QuotasContainer
    $data.SystemsContainer          = $domain.SystemsContainer
    $data.UsersContainer            = $domain.UsersContainer
    $data.PartitionsContainer       = $forest.PartitionsContainer
    $data.configurationNamingContext= $rootDse.configurationNamingContext
    $data.DsServiceName             = $rootDse.dsServiceName

    $data.OptionalFeatures          = Get-fnOptionalFeatures
    $data.Subnets                   = Get-fnSubets
    $data.UpnSuffixes               = Get-fnUpnSuffixes -Forest $forest
    $data.SpnSuffixes               = Get-fnSpnSuffixes -Forest $forest
    $data.ReplicationSiteLinks      = Get-fnReplicationSiteLinks
    
    $data.Sites                     = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
    $data.DomainCount               = ($forest.Domains).Count
    $data.SiteCount                 = ($forest.Sites).Count

    $data.PasswordPolicy            = Get-fnPasswordPolicy 

    $data.TrustedDomainObjects      = Get-fnTrustedObjects
    

    $totalTime = Stop-Timer -Start $startTimer
    Write-Verbose "Active Directory information gathering completed. It took $totalTime"

    return $data

        

}
# Get-fnActiveDirectoryInformation
