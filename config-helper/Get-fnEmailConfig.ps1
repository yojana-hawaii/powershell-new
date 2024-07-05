
function Get-fnEmailConfig {

    $emailConfig = Get-Content "$PWD\config\email-config.conf"
    
    $email = @()
    
    $emailConfig | ForEach-Object {
        $keys = $_ -split "="
        $email += @{$keys[0]=$keys[1]}
    }
    return $email
}

