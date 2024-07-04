function Get-fnForestFSMO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Forest
    )
    
    return [Ordered] @{
        'Domain Naming Master'  = $forest.DomainNamingMaster
        'Schema Master'         = $forest.SchemaMaster
   }
}