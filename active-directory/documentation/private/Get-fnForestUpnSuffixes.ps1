function Get-fnForestUpnSuffixes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Forest
    )
    
    begin {
        
    }
    
    process {
        @(
            [PSCustomObject]@{
                Name = $Forest.RootDomain
                Type = 'Primary/Default UPN'
            }
            foreach($upn in $Forest.UPSSuffixes){
                [PSCustomObject]@{
                 Name = $upn
                 Type = 'Secondary'
                }
            }
        )
    }
    
    end {
        
    }
}