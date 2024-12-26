function Get-fnInternalOrders {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$order
    )
    Write-Information "$($MyInvocation.MyCommand.Name): Separate internal orders using internal order csv file in"
    if( Test-Path -Path $order.internalList){
        $order.internalList = (Read-fnCsvDefaultHeader -filename $order.internalList).order
        
        $order.internaldata = $order.externaldata | Where-Object { $_.order -in $order.internalList}
        $order.externaldata = $order.externaldata | Where-Object { $_.order -notin $order.internalList}

    } else {
        Write-Warning "$($MyInvocation.MyCommand.Name): Internal order list for $($order.type) does not exist."
    }
    return $order
}