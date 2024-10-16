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
        [string]$group2
    )
    Remove-Item -Path $destinationPath -Force

    $today       = Get-Date
    $dataToGroup = Read-fnCsvDefaultHeader -filename $CsvfileToSplit | Where-Object {(New-TimeSpan -Start $_.performDate -End $today  ).Days -gt $excludeDays }
    $groupedData = Group-fnIntoTwoPropertyByCount -data $dataToGroup -CountSplit 50 -firstGroup $group1 -secondGroup $group2 
    return $groupedData
}