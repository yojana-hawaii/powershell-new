function Get-fnOrderConfig {
    [CmdletBinding()]
    param()

    $global = Get-Content "$PWD\config\order.conf"
    $conf = @()

    $global | ForEach-Object {
        $keys = $_ -split "="
        $conf += @{$keys[0]=$keys[1]}
    }
    return $conf
}