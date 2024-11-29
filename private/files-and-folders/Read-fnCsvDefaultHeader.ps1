function Read-fnCsvDefaultHeader {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$filename    
    )

    Write-Verbose "Reading csv file in Read-fnDefaultHeader.ps1"

    if (Test-Path -Path $filename){
        Write-Verbose "Test File path: File exists"
        try {
            $csvData = import-csv -Path $filename -Delimiter ","
            Write-Output "Successfully imported csv file."
        } catch {
            Write-Warning "Import CSV file failed: $($_.Exception.Message)"
        }
    } else {
        Write-Warning "Source file cannot be found: $($_.Exception.Message)"
    } 

   $csvData
}
