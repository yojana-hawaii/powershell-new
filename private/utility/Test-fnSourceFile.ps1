function Test-fnSourceFile {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]$sourceFile,
        [parameter()]
        [int]$sourceFileValidDays
    )
    $sourceFileValid = $false

    if (Test-Path -Path $sourceFile){
        Write-Information "Checking Test-fnSourceFile - Source file exists."
        
        $lastModified   = (Get-ChildItem -Path $sourceFile).LastWriteTime    
        $createdDate    = New-TimeSpan -Start $lastModified -End $today
        $createdDays    = $createdDate.TotalDays

        Write-Information "Source created on $lastModified, $($createdDate.TotalDays) days ago."
        $sourceFileValid = $createdDays -lt $sourceFileValidDays
        if( $sourceFileValid ){
            Write-Verbose "Source file exists and was modified within last $sourceFileValidDays days."
        }
    }

    return $sourceFileValid
}