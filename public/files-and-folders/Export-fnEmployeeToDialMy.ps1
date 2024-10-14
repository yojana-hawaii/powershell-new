function Export-fnEmployeeToDialMy {
    [CmdletBinding()]
    param()
    <# Get data from config file. Strip " (double quote). Pulling path from config file adds double quotes everywhere #>
   
    $config                         = Get-fnFiesAndFoldersConfig
    $sourceFile                     = (Join-Path -Path $config.employeeFilepath -ChildPath $config.employeeSourceFilename) -replace '"',""
    $additionalPhoneNumbersFile     = (Join-Path -Path $config.employeeFilepath -ChildPath $config.additionalPhoneNumbers) -replace '"',""
    $dialMyCsv                      = (Join-Path -Path $config.employeeFilepath -ChildPath $config.dialMyCsv) -replace '"',""
    $activeDirectoryCsv             = (Join-Path -Path $config.employeeFilepath -ChildPath $config.activeDirectoryCsv) -replace '"',""
    $azureDirectoryCsv              = (Join-Path -Path $config.employeeFilepath -ChildPath $config.azureDirectoryCsv) -replace '"',""
    $validateCsv                    = (Join-Path -Path $config.employeeFilepath -ChildPath $config.validateCsv) -replace '"',""
    $org2                           = ($config.organization2) -replace '"',""
    $sourceFileHeader               = ($config.sourceFileHeader) -replace '"',""
    
    $employees = Convert-fnCsvToEmployee -sourceFile $sourceFile -org2 $org2 -sourceFileHeader $sourceFileHeader
    $employees = Add-fnMissingPhoneNumbers -employees $employees -additionalPhoneNumbersFile $additionalPhoneNumbersFile

    $employees | Select-Object Last,First,cellPhone,dialGroup | Export-csv -Path $dialMyCsv -NoTypeInformation
    $employees | Select-Object Last,First,hrEmail,cellPhone,staffEmail,manager,managerEmail,location,department,jobtitle,orgGroup | Export-csv -Path $validateCsv -NoTypeInformation
    $employees | Where-Object {$_.department -ne $org2} | Select-Object Last,First,staffEmail,manager,managerEmail,location,department,jobtitle | Export-csv -Path $activeDirectoryCsv -NoTypeInformation
    $employees | Where-Object {$_.department -eq $org2} | Select-Object Last,First,staffEmail,manager,managerEmail,location,department,jobtitle | Export-csv -Path $azureDirectoryCsv -NoTypeInformation
        
}

# Export-fnEmployeeToDialMy -Verbose