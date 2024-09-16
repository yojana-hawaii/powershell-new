function Add-fnActiveDirectory {
    $ActiveDirectoryData = Get-fnActiveDirectory -Verbose

    $startTimer = Start-Timer
    foreach($data in $ActiveDirectoryData.GetEnumerator()){
        Add-spActiveDirectory -ActiveDirectory $data -Verbose
    }

    $totalTime = Stop-Timer -Start $startTimer
    Write-Verbose "Active Directory insert completed. It took $totalTime"
}