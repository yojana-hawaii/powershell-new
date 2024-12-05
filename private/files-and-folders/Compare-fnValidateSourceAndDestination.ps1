function Compare-fnValidateSourceAndDestination {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$orderHash
    )

    $sourceFileValidDays    = 7

    $fileValidation =@{
        sourceValid = $false
        destinationValid = $false
    }

    Write-Verbose "Validate source file is less a week old and destination file was created after source file in Compare-fnValidateSourceAndDestination.ps1"
    
    <# 1. Validate source file exists #>
    if (Test-Path -Path $orderHash.source){
        try {
            $sourceModified = (Get-ChildItem -Path $orderHash.source).LastWriteTime
            $fileValidation.sourceValid    = $true
            Write-Information "1a. Source file $($orderHash.source) last modified: $sourceModified"
        } catch {
            Write-Information "1c. Create source file. Cannot find: $($_.Exception.Message)"
            return $fileValidation
        }
    } else {
        Write-Information "1b. Missing source file. $($orderHash.source)"
        return $fileValidation
    }
    
    <# 2. Validate destination file exists #>
    if (Test-Path -Path $orderHash.extDestination){
        try {
            $file_dest      = Get-ChildItem -Path $orderHash.extDestination
            $destModified   = ($file_dest.LastWriteTime)[0]
            $fileValidation.destinationValid   = $true
            Write-Information "2a. Destination file $($file_dest[0]) last modified: $destModified"
        } catch {
            Write-Information "2c. Create destination file. Cannot find destination file: $($_.Exception.Message)"
            return $fileValidation
        }
    } else {
        Write-Information "2b. Cannot find destination folder $($orderHash.extDestination)"
        return $fileValidation
    }

    <# 3. Source file was created within last 7 days#>
    if($fileValidation.sourceValid ) {
        $SourceFileCreated = New-TimeSpan -Start $sourceModified -End $today
        Write-Information "3. Source file was created $($SourceFileCreated.TotalDays) days ago"
   
        if($SourceFileCreated.TotalDays -ge  $sourceFileValidDays){
            $fileValidation.sourceValid = $false
            Write-Information "3b. Source file is to old"
        } else {
            Write-Information "3a. Source file is good."
        }
    }
    
    <# 4. Destination file was created after source file #>
    if($fileValidation.sourceValid -and $fileValidation.destinationValid){
        $DestinationFileCreated = New-TimeSpan -Start $sourceModified -End $destModified
        Write-Information "4. Destination file was created $($DestinationFileCreated.TotalMinutes) minutes after source file"
        
        if($DestinationFileCreated -le 1 ){
            $fileValidation.destinationValid = $false
            Write-Information "4b. Destination file was created before source file"
        } else {
            Write-Information "4a. Destination file is good."
        }
    }

    <# 5. if both true no action needed #>
   
    return $fileValidation
    
}