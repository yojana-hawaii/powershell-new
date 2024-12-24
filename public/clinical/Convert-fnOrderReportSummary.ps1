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

    Write-Verbose "Initializing order and email configs."
    $order = Initialize-fnOrderConfigs
    $email = Initialize-fnOrderEmailConfigs 
    $sendEmail = $false
 
    $OrdersToDelete = $null
    $lab = $null
    Write-Verbose "Looping through $($order.type)"
    for($i=0; $i -le ($order.Count - 1); $i++){
        Write-Information "Current loop - $($order[$i].type )"

        if( -not (Test-fnSourceFile -sourceFile $order[$i].source -sourceFileValidDays 7) ){
            Update-fnInvalidSource -email $email -type $order[$i].type -sourceFile $order[$i].source 
            $sendEmail = $true
        } else {

            if (Test-fnDestinationFile -sourceFile $order[$i].source -destinationFile $order[$i].extDestination ){
                Update-fnValidSourceAndDestination -email $email -type $order[$i].type
            }
            else {
                $order[$i] =  Update-fnInValidDestination -email $email -order $order[$i]
                $sendEmail = $true

                $OrdersToDelete += $order[$i].deletedata
            }
        }    
    }
    
    $OrdersToDelete | Where-Object {$null -ne $_ }| Export-csv -Path "$($order[0].delDestination)\delete.csv" -NoTypeInformation


    if($sendEmail) {
        
        $email = Update-fnEmailBodyHtml -email $email
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

