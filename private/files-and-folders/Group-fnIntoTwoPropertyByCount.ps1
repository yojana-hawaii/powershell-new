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
        [string]$secondGroup
    )

    Write-Verbose "Group dataset by two property. First group $firstgroup if count over $countSplit. Remaining in second group $secondGroup "
    $grouped = $data | Group-Object -Property $firstGroup
    $provider = $grouped | Where-Object { $_.Count -ge $CountSplit}

    $dept = ($grouped |Where-Object { $_.count -lt $CountSplit } | select-object -ExpandProperty Group) | Group-Object -Property $secondGroup

    $grouped = $provider + $dept
    return $grouped 
}