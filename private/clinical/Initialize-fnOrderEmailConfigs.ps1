function Initialize-fnOrderEmailConfigs {
    [CmdletBinding()]
    param (

    )
    $emailConfig        = Get-fnEmailConfig
    
    Write-Information "Initializing PSCustomObject for email.... in Initialize-fnOrderEmailConfigs"
    $email = [PSCustomObject]@{
        smtp            = ($emailConfig.smtp) -replace '"',""
        from            = ($emailConfig.myEmail) -replace '"',""
        to              = (($emailConfig.orderTo) -replace '"',"").Split(';')
        cc              = (($emailConfig.orderCC) -replace '"',"").Split(';')
        subject         = ($emailConfig.orderSubject) -replace '"',""
        bodyashtml      = $true
        body            = ""
        emailSig        = ($emailConfig.mySig) -replace '"',""

        emailBody1 = "Hello all, This is an automated email for incomplete labs, consults & imaging."
        emailBody2 = ""       # do nothing
        emailBody3 = ""       # download source files 
        emailBody3a = ""      # source file unc
        emailBody4 = @{}      # file location
        emailBody5 = $null    # array of array into html table
        emailBody6 = @{}      # applied filters for transparency
    }

    return $email
}