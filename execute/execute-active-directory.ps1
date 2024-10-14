

$configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"                          -ErrorAction SilentlyContinue -Recurse)
$public             = @(Get-ChildItem -Path "$PWD\public\active-directory\*.ps1"                -ErrorAction SilentlyContinue -Recurse)
$private            = @(Get-ChildItem -Path "$PWD\private\active-directory\*.ps1"               -ErrorAction SilentlyContinue -Recurse)
$StoredProcedure    = @(Get-ChildItem -Path "$PWD\stored-procedure\active-directory\*.ps1"      -ErrorAction SilentlyContinue -Recurse)

Write-Verbose "Read public, private & shared functions, stored procedures and config helpers"
#import all function
foreach ($import in @($configHelper + $private + $public + $StoredProcedure)){
    try{
        . $import.Fullname
        Write-Verbose "importing $($import.Fullname)"
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }
    
}

Add-fnActiveDirectory -verbose
Add-fnOrganizationalUnit -verbose