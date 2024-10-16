function Read-fnSourceAndDestinationDates {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]$sourceFile,
        [parameter()]
        [int]$sourceFileValidDays,
        [parameter()]
        [array]$destinationFiles
    )
    $today       = Get-Date
    $sourceFileValid = $false
    $destinationFileValid = $false
    
    <# 1. Validate source file exists #>
    if (Test-Path -Path $sourceFile){
        $file_source    = Get-Item -Path $sourceFile
        $sourceModified = $file_source.LastWriteTime
        $sourceFileValid = $true
        Write-Verbose "Source file last modified: $sourceModified"
    } else {
        Write-Warning "Create source file. Cannot read source file: $($_.Exception.Message)"
    }
    
    <# 4. Validate destination file exists #>
    if (Test-Path -Path $labFileDestination){
        $file_dest      = Get-Item -Path $labFileDestination
        $destModified   = ($file_dest.LastWriteTime)[0]
        Write-Verbose "Destination file last modified: $destModified"
        $destinationFileValid = $true
    } else {
        Write-Warning "Create destination file. Cannot find destination file: $($_.Exception.Message)"
    }
    
    <# 4. Destination file was created after source file #>
    if($sourceFileValid -and $destinationFileValid){
        $DestinationFileCreated = New-TimeSpan -Start $sourceModified -End $destModified
        Write-Verbose "Destination file was created $($DestinationFileCreated.TotalMinutes) minutes after source file"
    }
    if($DestinationFileCreated -le 1 ){
        $destinationFileValid = $false
        Write-Verbose "Destination file was created before source file"
    } else {
        Write-Verbose "Destination file is good."
    }

    <# 2. Source file was created within last 7 days#>
    if($sourceFileValid ) {
        $SourceFileCreated = New-TimeSpan -Start $sourceModified -End $today
        Write-Verbose "Source file was created $($SourceFileCreated.TotalDays) days ago"
    }
    if($SourceFileCreated.TotalDays -ge  $sourceFileValidDays){
        $sourceFileValid = $false
        Write-Verbose "Source file is to old"
    } else {
        Write-Verbose "Source file is good."
    }

    <# 5. if both true no action needed #>
   
    return @( $sourceFileValid, $destinationFileValid )
}