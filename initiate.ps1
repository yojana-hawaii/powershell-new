# import only specific functions in the future -> only users if I am working on users

$public             = @(Get-ChildItem -Path "$PWD\public\*.ps1"     -ErrorAction SilentlyContinue -Recurse)
$private            = @(Get-ChildItem -Path "$PWD\private\*.ps1"    -ErrorAction SilentlyContinue -Recurse)
$shared             = @(Get-ChildItem -Path "$PWD\shared\*.ps1"     -ErrorAction SilentlyContinue -Recurse)
$config             = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"     -ErrorAction SilentlyContinue -Recurse)
$StoredProcedure    = @(Get-ChildItem -Path "$PWD\stored-procedure\*.ps1"     -ErrorAction SilentlyContinue -Recurse)



Write-Verbose "Read public, private & shared functions, stored procedures and config helpers"
#import all function
foreach ($import in @($public + $private + $shared + $StoredProcedure + $config)){
    try{
        . $import.Fullname
        Write-Verbose "importing $($import.Fullname)" #-Verbose
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }
    
}

# $VerbosePreference = "continue"
$VerbosePreference = "silentlycontinue"

<# using config file #>
# $conf = Get-fnConfig
# $conf.Domain
# $email = Get-fnEmailConfig
# $email.helpdesk


<# active-directory #>
Add-fnActiveDirectory -Verbose

<# organizational-unit and acl#>
Add-fnOrganizationalUnit -verbose

<# group-policy #>
# Get-fnGPO | Format-Table -AutoSize *

