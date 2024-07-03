function Get-fnForestSpnSuffixes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$forest
    )
    return @(
        foreach($Spn in $forest.SPNSuffixes){
            [PSCustomObject]@{
                Name = $Spn
            }
        }
    )
}