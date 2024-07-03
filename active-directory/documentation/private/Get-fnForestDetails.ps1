function Get-fnForestDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$forest,
        [Parameter(Mandatory)]
        [Microsoft.ActiveDirectory.Management.ADRootDSE] $rootDSE
    )

    return [ordered] @{
        Name                        = $forest.Name
        RootDomain                  = $forest.RootDomain
        ForestDistinguishedName     = $rootDSE.DefaultNamingContext
        ForestFunctionalLevel       = $forest.ForestMode
        DomainCount                 = ($forest.Domains).Count
        SiteCount                   = ($forest.Sites).Count
        Domains                     = ($forest.Domains) -join ", "
        Sites                       = ($forest.Sites) -join ", " 
    }
}