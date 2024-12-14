function Remove-fnOrderNotReadyForFollowup {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$orderHash
    )
    Write-Verbose "Remove file that are not due for follow up in Remove-fnOrderNotReadyForFollowup.ps1"
    $filterColumn=($orderHash.alarm[0]).ToString()
    $filterValue=$orderHash.alarm[1]
    $excludeColumn1=($orderhash.exclude[0]).ToString()
    $excludeValue1=($orderhash.exclude[1]).ToString()
    $excludeColumn2=($orderhash.exclude[2]).ToString()
    $excludeValue2=($orderhash.exclude[3]).ToString()
    
   <# 
    1. read file
    2. remove data not ready for alarm
    3. remove data with additional exceptions
   #>
    $data = Read-fnCsvDefaultHeader -filename $orderHash.source
    Write-Information "Removing closed orders"
    $data = $data | Where-Object {$_.currentStatus -ne "closed" }
    Write-Information "Removing orders from past $filterValue days"
    $data = $data | Where-Object {$null -ne $_.$filterColumn -and $_.$filterColumn -ne "" ` -and (New-TimeSpan -Start $_.$filterColumn -End $today  ).Days -gt $filterValue }

    Write-Information "Removing orders in $excludeValue1 $excludeColumn1 from past $excludeValue2 $excludeColumn2 days"
    $data = $data | Where-Object { -not ($_.$excludeColumn1 -eq $excludeValue1  ` -and  (New-TimeSpan -Start $_.$excludeColumn2 -End $today  ).Days -le $excludeValue2 )}

    Write-Information "$($data.count) $($orderHash.type) orders need to be closed"

    $orderHash.externaldata = $data 
    return $orderHash
}