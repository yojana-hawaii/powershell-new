function Update-fnInvalidDestination {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email,
        [parameter()]
        [System.Object]$order
    )
    Write-Information "Create new Destination files in Convert-fnOrderReportSummary "
    $order = Remove-fnOrderNotReadyForFollowup -order $order
    $order = Get-fnDeletedOrders -order $order
    $order = Get-fnInternalOrders -order $order
    
    $order = Group-fnOrdersByGroupConfig -order $order
        
    Export-fnGroupedObjectToSeparateCsv -groupObject $order.internaldata -destination $order.intDestination
    Export-fnGroupedObjectToSeparateCsv -groupObject $order.externaldata -destination $order.extDestination

    Update-fnEmailBodyInvalidDestination -email $email -order $order
    
    return $order
}