function Read-fnCsvDefaultHeader {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$filename    
    )

    Write-Verbose "Adding additional phone numbers missing in original csv file"

    if (Test-Path -Path $filename){
        Write-Verbose "Test File path: File exists"
        try {
            $csvData = import-csv -Path $filename -Delimiter ","
            Write-Verbose "Successfully imported additional phone csv file"
        } catch {
            Write-Warning "Import CSV file failed: $($_.Exception.Message)"
        }
    } else {
        Write-Warning "Source file cannot be found: $($_.Exception.Message)"
    } 

   $csvData
}
