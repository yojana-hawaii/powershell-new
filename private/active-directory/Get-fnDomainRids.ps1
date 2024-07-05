function Get-fnDomainRids {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $DistinguishedName,
        [Parameter()]
        [string] $RidMaster
    )

    try {
        Write-Verbose "Getting RIDS details"
        $ridContainer = "cn=rid manager$,cn=system,$DistinguishedName"
        $rIDs = Get-ADObject $ridContainer -Property RidAvailablePool -Server $RidMaster

        return $rIDs.RidAvailablePool
        
     } catch {
         Write-Warning "Get-fnDomainRids failed: $($_.Exception.Message) "
     continue
     }
    
}
