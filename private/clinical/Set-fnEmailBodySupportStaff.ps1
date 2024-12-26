function Set-fnEmailBodySupportStaff {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email,
        [parameter()]
        [System.Object]$task
    )

    Set-fnEmailBodyNull -email $email
    Write-Information "$($MyInvocation.MyCommand.Name): Set email body"

    $providers = $task.Group.Provider -join ", "
    $email.To = $task.Group.Email | Get-Unique
    $email.cc = $email.supportcc

    $email.Subject = "Incomplete labs for $providers"

    $email.emailBody1 = "<p>Hello $($task.Group.staff | Get-Unique),</p>"
    
    $email.emailbody2 = "<p>This is an automated email for incomplete labs for Provider(s) $providers</p>"

    $email.emailbody3 = "<p>The list of incomplete labs can be found in <br>
    <ul>
        $(foreach($unc in $task.Group.File){
            "<li>$unc</li>"
        })
    </ul>
    </p>"
    $email.emailBody4 = "<p>This list includes
    <ul>
    <li>Lab result not back 7 days after perform date.</li>
    <li>Lab orders in FutureLab bucket past 90 days of perform date.</li>
    </ul>
    </p>"
    
    $email.emailbody5 = "To: $($email.to) CC: $($email.cc)"

}