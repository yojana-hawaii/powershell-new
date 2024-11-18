function Group-fnIntoTwoPropertyByCount {
    [CmdletBinding()]
    param (
        [Parameter()]
        [array]$data,
        [parameter()]
        [int16]$CountSplit,
        [parameter()]
        [string]$firstGroup,
        [parameter()]
        [string]$secondGroup,
        [parameter()]
        [string]$deletedBucket
    )

    Write-Verbose "Separate group for deleted buckets"
    $deleted = $data | Where-Object {$_.Bucket -eq $deletedBucket} | Group-Object -Property "Bucket"

    Write-Verbose "Group dataset by two property. First group $firstgroup if count over $countSplit. Remaining in second group $secondGroup "
    $grouped = $data | Where-Object {$_.Bucket -ne $deletedBucket}| Group-Object -Property $firstGroup
    $provider = $grouped | Where-Object { $_.Count -ge $CountSplit}

    $dept = ($grouped |Where-Object { $_.count -lt $CountSplit } | select-object -ExpandProperty Group) | Group-Object -Property $secondGroup

    $grouped = $provider + $dept
    $grouped = $grouped + $deleted
    return $grouped 
}