function Set-fnEmailHtmlCombine {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email
    )

    Write-Information "$($MyInvocation.MyCommand.Name): Set email body to html"

    # send test email to myself
    #$email.To = $email.From
    #$email.CC = $email.From
    
    $email.body = "
            $($email.htmlStart)
            $(if($null -ne $email.emailBody1) {$email.emailBody1})
            $(if($null -ne $email.emailBody2) {$email.emailBody2})
            $(if($null -ne $email.emailBody3) {$email.emailBody3})  


            $(if($null -ne $email.emailBody4) {$email.emailBody4})  
            $(if($null -ne $email.emailBody5) {$email.emailBody5})  
            $(if($null -ne $email.emailBody6) {$email.emailBody6})  

            <p style=`"text-align:left`">Thank you,</br>$($email.emailSig) </p> 
            
            $($email.htmlEnd)
            "
    
}