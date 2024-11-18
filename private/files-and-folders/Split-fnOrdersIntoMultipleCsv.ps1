function Split-fnCsvIntoMultipleCsv {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]$CsvfileToSplit,
        [parameter()]
        [string]$destinationPath,
        [parameter()]
        [int]$excludeDays=0,
        [parameter()]
        [string]$group1,
        [parameter()]
        [string]$group2,
        [parameter()]
        [string]$futureLabBucket,
        [parameter()]
        [string]$deletedBucket
    )
    Remove-Item -Path $destinationPath -Force

    $today      = Get-Date
    $pastDue    = Read-fnCsvDefaultHeader -filename $CsvfileToSplit | Where-Object {(New-TimeSpan -Start $_.performDate -End $today  ).Days -gt $excludeDays }
    
    $regular    = $pastDue | Where-Object {$_.bucket -ne $futureLabBucket }
    $future     = $pastDue | Where-Object {$_.bucket -eq $futureLabBucket -and (New-TimeSpan -Start $_.performDate -End $today  ).Days -gt 90}
    
    $dataToGroup = $regular + $future
    $groupedData = Group-fnIntoTwoPropertyByCount -data $dataToGroup -CountSplit 50 -firstGroup $group1 -secondGroup $group2 -deletedBucket $deletedBucket
    return $groupedData
}