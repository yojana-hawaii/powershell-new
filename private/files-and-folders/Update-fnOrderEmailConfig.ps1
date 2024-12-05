function Update-fnOrderEmailConfig {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$email
    )

    Write-Verbose "Set email config in Update-fnOrderEmailConfig.ps1"
   
    $email.body = "<!DOCTYPE html PUBLIC `"-//W3C//DTD XHTML 1.0 Strict//EN`"  `"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd`"> 
    <html xmlns=`"http://www.w3.org/1999/xhtml`">
    <head> 
        <title> Incomplete Order</title>
        <meta name=`"generator`" content=`"powershell`"/>
        <style>
            table,td,th  {
                border:1px solid black;
                border-collapse:collapse
            }
            table td {
                text-align:center
            }
            table th {
                padding: 0 15px
            }
        </style>
    </head>
    <body>
        <div>$($email.emailBody1)
        $(if ($email.emailbody2.length -ge 1){
            "<p>File for $($email.emailBody2.substring(0, $email.emailBody2.length-1)) was generenated within last 7 days.</p>"
        })
        $(if ($email.emailBody3.length -ge 1){
            "<p>From Athena Inbox, please download new report for $($email.emailBody3.substring(0, $email.emailBody3.length-1)). Save the file to $($email.emailBody3a). Replace existing file.</p>"
        })
        </div>
        <div>
            <p><strong>File Location</strong>
                <ul>
                    $(foreach($loc in $email.emailBody4.GetEnumerator()){
                        "<li>$($loc.key) - $($loc.value)</li>"
                    })
                </ul>
            </p>
        </div>
        <div>
            <p><strong>Summary of Incomplete Order</strong>
                $($email.emailBody5 | ConvertTo-Html -Fragment)
            </p>
        </div>
        </br>
        <div>
            </p><strong>Applied Filters</strong>
                <ul>
                    <li>Closed orders are not included</li>
                    <li>Deleted orders are not included</li>
                    <li>Orders waiting to be deleted in DeleteDocument bucket are in separate file.</li>
                    <li>Following criteria must be met to be included in  this list 
                        <ul>
                            <li>Consult result not back 42 days after ordering.</li>
                            <li>Imaging result not back 30 days after ordering.</li>
                            <li>Lab result not back 7 days after ordering.</li>
                            <li>Lab in FutureLab bucket (patient no show but still valid) waiting for 90 days of perform date.</li>
                        </ul>
                    </li>
                    <li>Order performed in-house (best guess looking at Athena setup)
                        <ul>
                            $(foreach($loc in $email.emailBody6.GetEnumerator()){
                                "<li>$($loc.key) - $($loc.value)</li>"
                            })
                        </ul>
                    </li>
                <ul>
            </p>
        </div>
        </br>
        <div>
            <p style=`"text-align:left`">Thank you,</br>$($email.emailSig) </p>  
        </div>
    </body>
    </html>"



    return $email
    
}