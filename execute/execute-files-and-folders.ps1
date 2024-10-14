
$configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"                          -ErrorAction SilentlyContinue -Recurse)
$public             = @(Get-ChildItem -Path "$PWD\public\files-and-folders\*.ps1"   -ErrorAction SilentlyContinue -Recurse)
$private            = @(Get-ChildItem -Path "$PWD\private\files-and-folders\*.ps1"  -ErrorAction SilentlyContinue -Recurse)

Write-Verbose "Read public & private functions, stored procedures and config helpers"
#import all function
foreach ($import in @($configHelper + $private + $public)){
    try{
        . $import.Fullname
        Write-Output "importing $($import.Fullname)"
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }
    
}

Export-fnEmployeeToDialMy -Verb

<# moving away from RAVE
Export-fnLatestEmployeeRosterToRave -Verbose
#>