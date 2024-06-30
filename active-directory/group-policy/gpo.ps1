$publicGpo = @(Get-ChildItem -Path "$PWD\active-directory\group-policy\public\*.ps1" -ErrorAction SilentlyContinue -Recurse)
$privateGpo = @(Get-ChildItem -Path "$PWD\active-directory\group-policy\private\*.ps1" -ErrorAction SilentlyContinue -Recurse)
$shared = @(Get-ChildItem -Path "$PWD\active-directory\shared\*.ps1" -ErrorAction SilentlyContinue -Recurse)



#import all function
foreach ($import in @($publicGpo + $privateGpo + $shared)){
    try{
        . $import.Fullname
    } catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
        $true
    }

}
# $conf = Get-fnConfig


Get-fnGPO | Format-Table -AutoSize *