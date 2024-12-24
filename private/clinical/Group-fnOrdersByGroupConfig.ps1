function Group-fnOrdersByGroupConfig {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$order
    )
    Write-Information "Group internal, external and delete data for $($order.type) in Group-fnOrderReportSummary"
    $order.extSummary     = $order.externaldata | Group-Object -Property $order.summaryGroup | Select-Object Name, Count
    $order.intSummary     = $order.internaldata | Group-Object -Property $order.summaryGroup | Select-Object Name, Count

    $order.deletedata     = $order.deletedata   | Group-Object -Property $order.deletegroup
    $order.internaldata   = $order.internaldata | Group-Object -Property $order.internalgroup
    $order.externaldata   = $order.externaldata | Group-Object -Property $order.externalgroup

    return $order
}