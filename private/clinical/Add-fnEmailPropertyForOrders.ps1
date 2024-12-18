function Add-fnEmailPropertyForOrders {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email
    )

    Add-Member -InputObject $email -NotePropertyName emailBody1 -NotePropertyValue "Hello all, This is an automated email for incomplete labs, consults & imaging."
    $email | Add-Member -MemberType NoteProperty -Name emailBody2 -Value ""       # do nothing
    $email | Add-Member -MemberType NoteProperty -Name emailBody3 -Value ""       # download source files 
    $email | Add-Member -MemberType NoteProperty -Name emailBody3a -Value ""      # source file unc 
    $email | Add-Member -MemberType NoteProperty -Name emailBody4 -Value @{}      # file location
    $email | Add-Member -MemberType NoteProperty -Name emailBody5 -Value $null    # array of array into html table
    $email | Add-Member -MemberType NoteProperty -Name emailBody6 -Value @{}      # applied filters for transparency
    $email.emailBody4["DELETE"] = $orderConfig[0].delDestination

}