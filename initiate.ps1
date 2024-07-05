# import only specific functions in the future -> only users if I am working on users

$public     = @(Get-ChildItem -Path "$PWD\public\*.ps1"     -ErrorAction SilentlyContinue -Recurse)
$private    = @(Get-ChildItem -Path "$PWD\private\*.ps1"    -ErrorAction SilentlyContinue -Recurse)
$shared     = @(Get-ChildItem -Path "$PWD\shared\*.ps1"     -ErrorAction SilentlyContinue -Recurse)



Write-Verbose "Read public, private and shared functions"
#import all function
foreach ($import in @($public + $private + $shared)){
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


# $conf = Get-fnConfig
# $conf.Domain



# group-policy
# Get-fnGPO | Format-Table -AutoSize *

# active-directory
Get-fnActiveDirectoryInformation -Verbose