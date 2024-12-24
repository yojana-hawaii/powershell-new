function Update-fnValidSourceAndDestination {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email,
        [parameter()]
        [string]$type
    )
    Write-Information "Do nothing for $type in Update-fnValidSourceAndDestination"
    $email.emailBody2 += "$type,"
}