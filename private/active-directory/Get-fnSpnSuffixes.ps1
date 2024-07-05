function Get-fnSpnSuffixes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$forest
    )
    Write-Verbose "Getting SPN Suffixes"
    return @(
        foreach($Spn in $forest.SPNSuffixes){
            [PSCustomObject]@{
                Name = $Spn
            }
        }
    )
}