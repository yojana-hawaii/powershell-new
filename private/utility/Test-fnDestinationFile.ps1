function Test-fnDestinationFile {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]$sourceFile,
        [parameter()]
        [string]$destinationFile
    )
    $destinationFileValid = $false

    if(Test-Path -Path $destinationFile){
        Write-Information "Checking Test-fnDestination - Destination file exists."

        try{
            $destinationModified    = ((Get-ChildItem -Path $destinationFile).LastWriteTime)[0]
            $sourceModified         = (Get-ChildItem -Path $sourceFile).LastWriteTime
     
            $differenceInMinutes    = (New-TimeSpan -Start $sourceModified -End $destinationModified).TotalMinutes
            $destinationFileValid   = $differenceInMinutes -gt 1

            if($destinationFileValid){
                Write-Verbose "Destination file exists and created $([int]$differenceInMinutes) minutes after source file."
            }
            return $destinationFileValid

        } catch {
            Write-Verbose "Error Destination path empty. Someone deleted all the files. "
            return $destinationFileValid
        } 
    }
    
}