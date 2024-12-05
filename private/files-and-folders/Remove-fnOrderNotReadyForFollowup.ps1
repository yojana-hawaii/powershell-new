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
    $data = $data | Where-Object {$_.currentStatus -ne "closed" }
    $data = $data | Where-Object {$null -ne $_.$filterColumn -and $_.$filterColumn -ne "" -and (New-TimeSpan -Start $_.$filterColumn -End $today  ).Days -gt $filterValue }
    $orderHash.externaldata = $data | Where-Object {-not ($_.$excludeColumn1 -eq $excludeValue1 -and (New-TimeSpan -Start $_.$excludeColumn2 -End $today  ).Days -gt $excludeValue2 )}
    return $orderHash
}