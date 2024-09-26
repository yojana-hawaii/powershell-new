function Get-fnRaveConfig {
    [CmdletBinding()]
    param()

    $global = Get-Content "$PWD\config\rave.conf"
    $conf = @()

    $global | ForEach-Object {
        $keys = $_ -split "="
        $conf += @{$keys[0]=$keys[1]}
    }
    return $conf
}

function Send-fnLatestEmployeeRoster {
    [CmdletBinding()]
    param()

    <# Get data from rave config file #>
    Write-Verbose "Get config variables."
    $rave = Get-fnRaveConfig

    <# Strip " (double quote). Pull path from config file adds double quotes everywhere #>
    $username = ($rave.username) -replace '"', ""
    $password = ($rave.password) -replace '"', ""
    $sourceFile = (Join-Path -Path $rave.sourceFilepath -ChildPath $rave.sourceFilename) -replace '"',""
    $destinationUrl = ($rave.destinationUrl) -replace '"', ""


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


Send-fnLatestEmployeeRoster -Verbose