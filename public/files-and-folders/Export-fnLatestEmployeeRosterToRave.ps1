function Export-fnLatestEmployeeRosterToRave {
    [CmdletBinding()]
    param()

    <# Get data from rave config file #>
    Write-Verbose "Get config variables."
    $rave = Get-fnFiesAndFoldersConfig

    <# Strip " (double quote). Pull path from config file adds double quotes everywhere #>
    $username = ($rave.rave_username) -replace '"', ""
    $password = ($rave.rave_password) -replace '"', ""
    $sourceFile = (Join-Path -Path $rave.employeeFilepath -ChildPath $rave.employeeSourceFilename) -replace '"',""
    $destinationUrl = ($rave.rave_destinationurl) -replace '"', ""


    $webCredential = New-Object System.Net.NetworkCredential($username, $password)
    
    if (Test-Path -Path $sourceFile){
        Write-Verbose "Test File path: File exists"
    
        try {
            Write-Verbose "Uploading file $sourceFile  to $destinationUrl $username $password"
            $webclient = New-Object System.Net.WebClient
            $webClient.Credentials = $webCredential
            $webClient.UploadFile($destinationUrl, 'PUT', $sourceFile)
            Write-Verbose "Rave upload Success"
        } catch {
            Write-Warning "Rave upload failed: $($_.Exception.Message) "
        }
    
    } else {
        Write-Warning "Source file cannot be found: $($_.Exception.Message)"
    }
}


# Export-fnLatestEmployeeRosterToRave -Verbose