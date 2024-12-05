function Get-fnInternalOrders {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$objectHash
    )
    Write-Verbose "Separate internal orders using internal order csv file in Get-fninternalOrders.ps1"
    if( Test-Path -Path $objectHash.internalList){
        $objectHash.internalList = (Read-fnCsvDefaultHeader -filename $objectHash.internalList).order
        
        $objectHash.internaldata = $objectHash.externaldata | Where-Object { $_.order -in $objectHash.internalList}
        $objectHash.externaldata = $objectHash.externaldata | Where-Object { $_.order -notin $objectHash.internalList}

    } else {
        Write-Warning "Internal order list for $($objectHash.type) does not exist."
    }
    return $objectHash
}