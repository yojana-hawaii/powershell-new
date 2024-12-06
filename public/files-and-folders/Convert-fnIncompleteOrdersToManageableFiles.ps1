set-location "\\fileserver\it\apps\powershell"

function Convert-fnIncompleteOrdersToManageableFiles {
    [CmdletBinding()]
    param()

    #region - Import necessary configs and private functions #>

    Write-Verbose "Initialize private functions & config helpers in Convert-fnIncompleteOrdersToManageableFiles.ps1"
    $configHelper       = @(Get-ChildItem -Path "$PWD\config-helper\*.ps1"              -ErrorAction SilentlyContinue -Recurse)
    $private            = @(Get-ChildItem -Path "$PWD\private\files-and-folders\*.ps1"  -ErrorAction SilentlyContinue -Recurse)
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

    $orderConfig = Initialize-fnOrderConfigs
    $email = $orderConfig[3]
    $sendEmail = $false
    $orderConfig = $orderConfig[0..($orderConfig.Count - 2)]
    $email.emailBody4 = @{}
    $email.emailBody4["DELETE"] = $orderConfig[0].delDestination
    $email.emailBody6 = @{}
    
    for($i=0; $i -le ($orderConfig.Count - 1); $i++){
        Write-Verbose "Current loop, $($orderConfig[$i].type) back in Convert-fnIncompleteOrdersToManageableFiles.ps1"

        $email.emailBody4["Internal-$($orderConfig[$i].type)"] = $orderConfig[$i].intDestination
        $email.emailBody4["External-$($orderConfig[$i].type)"] = $orderConfig[$i].extDestination
        $email.emailBody6["$($orderConfig[$i].type)"] = $($orderConfig[$i].internalList)

        $fileStatus  = Compare-fnValidateSourceAndDestination -orderHash $orderConfig[$i]

        <# $fileStatus.sourceValid & $fileStatus.destinationValid > no action needed #>
        if ($fileStatus.sourceValid -and $fileStatus.destinationValid) {
            Write-Output "Do nothing for $($orderConfig[$i].type)"
            $email.emailBody2 += "$($orderConfig[$i].type),"
            continue
        }
        <# -not $fileStatus.sourceValid > email for new file #> 
        if( -not $fileStatus.sourceValid){
            Write-Output "Source file for $($orderConfig[$i].type) not valid in Convert-fnIncompleteOrdersToManageableFiles"
            $fileToDownload = (Split-Path $orderConfig[$i].source -Leaf) -replace ".csv", ""
            $email.emailBody3 += "$($orderConfig[$i].type) ($fileToDownload),"
            $email.emailBody3a = "$(Split-Path $orderConfig[$i].source -Parent)"
            $sendEmail = $true
            continue
        }
        <#  -not $fileStatus.destinationValid  > create destination file #>
        if( -not $fileStatus.destinationValid){
            Write-Information "Create new Destination files in Convert-fnIncompleteOrdersToManageableFiles "
            $orderConfig[$i] = Remove-fnOrderNotReadyForFollowup -orderHash $orderConfig[$i]
            $orderConfig[$i] = Get-fnDeletedOrders -objectHash $orderConfig[$i]
            $orderConfig[$i] = Get-fnInternalOrders -objecthash $orderConfig[$i]
            
            $orderConfig[$i].extSummary     = $orderConfig[$i].externaldata | Group-Object -Property $orderConfig[$i].summaryGroup | Select-Object Name, Count
            $orderConfig[$i].intSummary     = $orderConfig[$i].internaldata | Group-Object -Property $orderConfig[$i].summaryGroup | Select-Object Name, Count

            $orderConfig[$i].deletedata     = $orderConfig[$i].deletedata   | Group-Object -Property $orderConfig[$i].deletegroup
            $orderConfig[$i].internaldata   = $orderConfig[$i].internaldata | Group-Object -Property $orderConfig[$i].internalgroup
            $orderConfig[$i].externaldata   = $orderConfig[$i].externaldata | Group-Object -Property $orderConfig[$i].externalgroup
            
            Export-fnGroupedObjectToSeparateCsv -groupObject $orderConfig[$i].internaldata -destination $orderConfig[$i].intDestination
            Export-fnGroupedObjectToSeparateCsv -groupObject $orderConfig[$i].externaldata -destination $orderConfig[$i].extDestination
            Export-fnGroupedObjectToSeparateCsv -groupObject $orderConfig[$i].deletedata -destination $orderConfig[$i].delDestination

            $email.emailBody5 = Join-fnTwoOrderArray -array1 $email.emailBody5 -array2 $orderConfig[$i].extSummary -type $orderConfig[$i].type -array2_prefix "External"            
            $email.emailBody5 = Join-fnTwoOrderArray -array1 $email.emailBody5 -array2 $orderConfig[$i].intSummary -type $orderConfig[$i].type -array2_prefix "Internal"      
            
            $sendEmail = $true
            continue
        }
        
        
    }
    if($sendEmail) {
        
        $email = Update-fnOrderEmailConfig -email $email
        Send-MailMessage -From $email.from -To $email.to -Cc $email.cc  -Subject $email.subject -Body $email.body -SmtpServer $email.smtp -BodyAsHtml
        # Send-MailMessage -From $email.from -To $email.from -Subject $email.subject -Body $email.body -SmtpServer $email.smtp -BodyAsHtml
    }

    $totalTime = Stop-Timer -Start $startTimer
    Write-Information "Csv file split file complete. It took $totalTime"    
}


Start-Transcript -Path "$pwd\log\Convert-fnIncompleteOrdersToManageableFiles_$mmddyyyy.txt"

$Global:today = $null
$today = Get-Date
$mmddyyyy = Get-Date -Format "MM-dd-yyyy"

Convert-fnIncompleteOrdersToManageableFiles  -Verbose -InformationAction Continue

Stop-Transcript

