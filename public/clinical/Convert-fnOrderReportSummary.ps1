set-location "\\fileserver\it\apps\powershell"

function Convert-fnOrderReportSummary {
    [CmdletBinding()]
    param()

    #region - Import necessary configs and private functions #>

    Write-Verbose "Initialize private functions & config helpers in Convert-fnOrderReportSummary.ps1"
    $configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"              -ErrorAction SilentlyContinue -Recurse)
    $private            = @(Get-ChildItem -Path "$PWD\private\clinical\*.ps1"  -ErrorAction SilentlyContinue -Recurse)
    $utility            = @(Get-ChildItem -Path "$PWD\private\utility\*.ps1"  -ErrorAction SilentlyContinue -Recurse)

    foreach ($import in @($configHelper + $private + $utility)){
        try{
            . $import.Fullname
            Write-Information "importing $($import.Fullname)"
        } catch {
            Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
            $true
        }
        
    }
    $import = $null
    #endregion
    
    $startTimer = Start-Timer

    $order = Initialize-fnOrderConfigs
    
    $email = Initialize-fnEmailConfigs
    Add-fnEmailPropertyForOrders -email $email
    $sendEmail = $false
 
    
    for($i=0; $i -le ($order.Count - 1); $i++){
        Write-Verbose "Current loop, $($order[$i].type) back in Convert-fnOrderReportSummary.ps1"

        $fileStatus  = Compare-fnValidateSourceAndDestination -orderHash $order[$i]

        <# $fileStatus.sourceValid & $fileStatus.destinationValid > no action needed #>
        if ($fileStatus.sourceValid -and $fileStatus.destinationValid) {
            Write-Output "Do nothing for $($order[$i].type)"
            $email.emailBody2 += "$($order[$i].type),"
            continue
        }
        <# -not $fileStatus.sourceValid > email for new file #> 
        if( -not $fileStatus.sourceValid){
            Write-Output "Source file for $($order[$i].type) not valid in Convert-fnOrderReportSummary"
            $fileToDownload = (Split-Path $order[$i].source -Leaf) -replace ".csv", ""
            $email.emailBody3 += "$($order[$i].type) ($fileToDownload),"
            $email.emailBody3a = "$(Split-Path $order[$i].source -Parent)"
            $sendEmail = $true
            continue
        }

        $email.emailBody4["Internal-$($order[$i].type)"] = $order[$i].intDestination
        $email.emailBody4["External-$($order[$i].type)"] = $order[$i].extDestination
        

        <#  -not $fileStatus.destinationValid  > create destination file #>
        if( -not $fileStatus.destinationValid){
            Write-Information "Create new Destination files in Convert-fnOrderReportSummary "
            $order[$i] = Remove-fnOrderNotReadyForFollowup -orderHash $order[$i]
            $order[$i] = Get-fnDeletedOrders -objectHash $order[$i]
            $order[$i] = Get-fnInternalOrders -objecthash $order[$i]
            
            $order[$i].extSummary     = $order[$i].externaldata | Group-Object -Property $order[$i].summaryGroup | Select-Object Name, Count
            $order[$i].intSummary     = $order[$i].internaldata | Group-Object -Property $order[$i].summaryGroup | Select-Object Name, Count

            $order[$i].deletedata     = $order[$i].deletedata   | Group-Object -Property $order[$i].deletegroup
            $order[$i].internaldata   = $order[$i].internaldata | Group-Object -Property $order[$i].internalgroup
            $order[$i].externaldata   = $order[$i].externaldata | Group-Object -Property $order[$i].externalgroup
            
            Export-fnGroupedObjectToSeparateCsv -groupObject $order[$i].internaldata -destination $order[$i].intDestination
            Export-fnGroupedObjectToSeparateCsv -groupObject $order[$i].externaldata -destination $order[$i].extDestination
            Export-fnGroupedObjectToSeparateCsv -groupObject $order[$i].deletedata -destination $order[$i].delDestination

            $email.emailBody5 = Join-fnTwoOrderArray -array1 $email.emailBody5 -array2 $order[$i].extSummary -type $order[$i].type -array2_prefix "External"            
            $email.emailBody5 = Join-fnTwoOrderArray -array1 $email.emailBody5 -array2 $order[$i].intSummary -type $order[$i].type -array2_prefix "Internal"      
            
            $sendEmail = $true
            continue
        }
        $email.emailBody6["$($order[$i].type)"] = $($order[$i].internalList)
        
    }
    if($sendEmail) {
        
        $email = Update-fnOrderEmailConfig -email $email
        # Send-MailMessage -From $email.from -To $email.to -Cc $email.cc  -Subject $email.subject -Body $email.body -SmtpServer $email.smtp -BodyAsHtml
        Send-MailMessage -From $email.from -To $email.from -Subject $email.subject -Body $email.body -SmtpServer $email.smtp -BodyAsHtml
    }

    $totalTime = Stop-Timer -Start $startTimer
    Write-Information "Csv file split file complete. It took $totalTime"    
}



$Global:today = $null
$today = Get-Date
$mmddyyyy = Get-Date -Format "MM-dd-yyyy"

Start-Transcript -Path "$pwd\log\Convert-fnOrderReportSummary_$mmddyyyy.txt" -Append
Convert-fnOrderReportSummary  -Verbose -InformationAction Continue
Stop-Transcript

