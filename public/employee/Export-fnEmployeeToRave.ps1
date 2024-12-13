function Export-fnEmployeeToRave {
    [CmdletBinding()]
    param()

    #region - Import necessary configs & utility functions #>
    Write-Verbose "Initialize private functions & config helpers in Export-fnEmployeeToRave.ps1"
    $configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\Get-fnEmployeeConfig.ps1"              -ErrorAction SilentlyContinue -Recurse)
    $utility            = @(Get-ChildItem -Path "$PWD\private\utility\*.ps1"  -ErrorAction SilentlyContinue -Recurse)

    foreach ($import in @($configHelper + $utility)){
        try{
            . $import.Fullname
            Write-Information "importing $($import.Fullname)"
        } catch {
            Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
            $true
        }
        
    }
    $import = $null
    #endregion

    Write-Verbose "Initialize rave config from employee config file."
    $rave = Get-fnEmployeeConfig

    Write-Verbose "Strip `" (double quote). Pull path from config file adds double quotes everywhere"
    $username = ($rave.rave_username) -replace '"', ""
    $password = ($rave.rave_password) -replace '"', ""
    $sourceFile = (Join-Path -Path $rave.employeeFilepath -ChildPath $rave.employeeSourceFilename) -replace '"',""
    $destinationUrl = ($rave.rave_destinationurl) -replace '"', ""


    $webCredential = New-Object System.Net.NetworkCredential($username, $password)
    
    if (Test-Path -Path $sourceFile){
        Write-Verbose "Source path: File exists"
    
        try {
            Write-Verbose "Uploading file $sourceFile  to $destinationUrl $username $password"
            $webclient = New-Object System.Net.WebClient
            $webClient.Credentials = $webCredential
            # $webClient.UploadFile($destinationUrl, 'PUT', $sourceFile)
            Write-Verbose "Rave upload Success"
        } catch {
            Write-Warning "Rave upload failed: $($_.Exception.Message) "
        }
    
    } else {
        Write-Warning "Source file cannot be found: $($_.Exception.Message)"
    }
}


$Global:today = $null
$today = Get-Date
$mmddyyyy = Get-Date -Format "MM-dd-yyyy"

Start-Transcript -Path "$pwd\log\Export-fnEmployeeToRave_$mmddyyyy.txt" -Append
Export-fnEmployeeToRave  -Verbose -InformationAction Continue
Stop-Transcript