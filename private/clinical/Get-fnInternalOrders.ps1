function Get-fnInternalOrders {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$order
    )
    Write-Information "Separate internal orders using internal order csv file in Get-fninternalOrders.ps1"
    if( Test-Path -Path $order.internalList){
        $order.internalList = (Read-fnCsvDefaultHeader -filename $order.internalList).order
        
        $order.internaldata = $order.externaldata | Where-Object { $_.order -in $order.internalList}
        $order.externaldata = $order.externaldata | Where-Object { $_.order -notin $order.internalList}

    } else {
        Write-Warning "Internal order list for $($order.type) does not exist."
    }
    return $order
}