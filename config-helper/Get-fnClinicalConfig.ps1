function Get-fnClinicalConfig {
    [CmdletBinding()]
    param()

    $global = Get-Content "$PWD\config\clinical.conf"
    $conf = @()

    $global | ForEach-Object {
        $keys = $_ -split "="
        $conf += @{$keys[0]=$keys[1]}
    }
    return $conf
}