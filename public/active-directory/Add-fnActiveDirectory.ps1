function Add-fnActiveDirectory {
    $ActiveDirectoryData = Get-fnActiveDirectory -Verbose
    
    foreach($data in $ActiveDirectoryData.GetEnumerator()){
        Add-spActiveDirectory -ActiveDirectory $data -Verbose
    }
}