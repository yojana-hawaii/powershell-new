



$configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"              -ErrorAction SilentlyContinue -Recurse)
$public             = @(Get-ChildItem -Path "$PWD\public\files-and-folders\*.ps1"   -ErrorAction SilentlyContinue -Recurse)
$private            = @(Get-ChildItem -Path "$PWD\private\files-and-folders\*.ps1"  -ErrorAction SilentlyContinue -Recurse)
$utility            = @(Get-ChildItem -Path "$PWD\private\utility\*.ps1"  -ErrorAction SilentlyContinue -Recurse)

Write-Output "Read public & private functions and config helpers"
#import all function
foreach ($import in @($configHelper + $private + $public + $utility)){
    try{
        . $import.Fullname
        Write-Output "importing $($import.Fullname)"
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }
    
}
$startTimer = Start-Timer

Export-fnIncompleteOrder -Verbose

$totalTime = Stop-Timer -Start $startTimer
Write-Output "Csv file split file complete. It took $totalTime"