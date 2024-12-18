function Initialize-fnEmailConfigs {
    [CmdletBinding()]
    param (

    )
    Write-Information "Create PSCustomObject for email."
    $email = [PSCustomObject]@{
        smtp            = ($emailConfig.smtp) -replace '"',""
        from            = ($emailConfig.me) -replace '"',""
        to              = (($emailConfig.orderTo) -replace '"',"").Split(';')
        cc              = (($emailConfig.orderCC) -replace '"',"").Split(';')
        subject         = "Incomplete orders (Labs, Consults & Imaging)."
        bodyashtml      = $true
        body            = ""
        emailSig        = "$emailName "
    }

    return $email
}