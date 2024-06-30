
function Get-fnConfig {

    $global = Get-Content "$($PWD.Path)\config\config.conf"
    
    $conf = @()
    
    $global | ForEach-Object {
        $keys = $_ -split "="
        $conf += @{$keys[0]=$keys[1]}
    }
    return $conf
}


