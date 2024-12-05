function Get-fnDeletedOrders {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$objectHash    
    )
    Write-Verbose "Separating deleted documents on $($objectHash.delete[0]) column on '$($objectHash.delete[1]) in Get-fnDeltedOrders.ps1'"
    $deleteColumn = ($objectHash.delete[0]).ToString()
    $deleteValue = ($objectHash.delete[1]).ToString()
    $data = $objectHash.externaldata
    $objectHash.deletedata = $data | Where-Object {$_.$deleteColumn -eq $deleteValue}
    $objectHash.externaldata = $data | Where-Object {$_.$deleteColumn -ne $deleteValue}
        
    return $objectHash
}