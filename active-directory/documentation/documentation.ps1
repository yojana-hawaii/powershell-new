
$publicAd   = @(Get-ChildItem -Path "$PWD\active-directory\documentation\public\*.ps1" -ErrorAction SilentlyContinue -Recurse)
$privateAd  = @(Get-ChildItem -Path "$PWD\active-directory\documentation\private\*.ps1" -ErrorAction SilentlyContinue -Recurse)
$shared     = @(Get-ChildItem -Path "$PWD\active-directory\shared\*.ps1" -ErrorAction SilentlyContinue -Recurse)



#import all function
foreach ($import in @($publicAd + $privateAd + $shared)){
    try{
        . $import.Fullname
        Write-Verbose "importing $($import.Fullname)" #-Verbose
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }

}
# $conf = Get-fnConfig
Get-fnForestInformation -Verbose