
$startTimer = Start-Timer

$configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"                          -ErrorAction SilentlyContinue -Recurse)
$public             = @(Get-ChildItem -Path "$PWD\public\active-directory\*.ps1"                -ErrorAction SilentlyContinue -Recurse)
$private            = @(Get-ChildItem -Path "$PWD\private\active-directory\*.ps1"               -ErrorAction SilentlyContinue -Recurse)
$StoredProcedure    = @(Get-ChildItem -Path "$PWD\stored-procedure\active-directory\*.ps1"      -ErrorAction SilentlyContinue -Recurse)
$utility            = @(Get-ChildItem -Path "$PWD\private\utility\*.ps1"  -ErrorAction SilentlyContinue -Recurse)

Write-Output "Read public, private & shared functions, stored procedures and config helpers"
#import all function
foreach ($import in @($configHelper + $private + $public + $StoredProcedure + $utility)){
    try{
        . $import.Fullname
        Write-Output "importing $($import.Fullname)"
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }
    
}

Add-fnActiveDirectory -verbose
Add-fnOrganizationalUnit -verbose


$totalTime = Stop-Timer -Start $startTimer
Write-Output "Active Directory and OU and OU ACL insert completed. It took $totalTime"