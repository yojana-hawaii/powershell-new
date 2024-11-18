function Export-fnIncompleteOrder {
    [CmdletBinding()]
    param()

    Write-Verbose "Get data from config file for orders. Strip `" (double quote)  "
    <# Get data from config file. Strip " (double quote). Pulling path from config file adds double quotes everywhere #>
    $config             = Get-fnFiesAndFoldersConfig
    $emailConfig        = Get-fnEmailConfig
    $labSourceFile      = (Join-Path -Path $config.labFilepath -ChildPath $config.labFileName) -replace '"',""
    $labAlarmDays       = $config.labAlarmDays
    $labFileDestination = (Join-Path -Path $config.labFileDestination -ChildPath "*") -replace '"',""
    $labGroups          = (($config.labGroups) -replace '"',"").Split(",")
    
    $labEmailSubject    = (($config.labEmailSubject) -replace '"',"")
    $labBodyGreetings   = (($config.labBodyGreetings) -replace '"',"")
    $labBodySuccess     = (($config.labBodySuccess) -replace '"',"")
    $labBodyDownloadSource   = (($config.labBodyDownloadSource) -replace '"',"")
    $labBodySignoff1    = (($config.labBodySignoff1) -replace '"',"")
    $labBodySignoff2    = (($config.labBodySignoff2) -replace '"',"")
    $labBodySignoff     = "$labBodySignoff1, `n$labBodySignoff2 "

    Write-Verbose "Get data from email config file"
    $smtp       = ($emailConfig.smtp) -replace '"',""
    $from       = ($emailConfig.me) -replace '"',""
    $toSuccess  = (($emailConfig.orderTo) -replace '"',"").Split(';')
    $ccSuccess  = (($emailConfig.orderCC) -replace '"',"").Split(';')
    $tofail     = (($emailConfig.me) -replace '"',"").Split(';')
    $ccfail     = (($emailConfig.me) -replace '"',"").Split(';')
    
    $to             = $toSuccess  
    $cc             = $ccSuccess  
    $subject        = $labEmailSubject
    
    
    
    $fileStatus = Read-fnSourceAndDestinationDates -sourceFile $labSourceFile -destinationFiles $labFileDestination -sourceFileValidDays 7
    
    <# 
        fileStatus[0] = $false > create source file 
        fileStatus[1] = $false > create destination file
        both true > no action needed 
    #>
    if( $fileStatus[0] -and $fileStatus[1]){
        Write-Verbose "Do nothing"
        return
    }
    $allFilesCreatedSuccessfully = $true
    if( -not $fileStatus[0]){
        Write-Verbose "Email to download source file - $($fileStatus[0])"
        $body       = "$labBodyGreetings`n`n$labBodyDownloadSource`n`n$labBodySignoff"
    } elseif( -not $fileStatus[1]){
        Write-Verbose "Create new Destination files grouped by $($labGroups[0]) and $($labGroups[1])"
        $groupedData = Split-fnCsvIntoMultipleCsv -CsvfileToSplit $labSourceFile -destinationPath $labFileDestination -excludeDays $labAlarmDays -group1 $labGroups[0] -group2 $labGroups[1] 
        $allFilesCreatedSuccessfully = Export-fnGroupObjectToSeparateCsv -GroupedObject $groupedData
        $body           = "$labBodyGreetings`n`n$labBodySuccess`n`n$labBodySignoff"
    }
    
    
    if(-not $allFilesCreatedSuccessfully){            
        $body = Write-Verbose "Files creation failed"
        $subject    = "$subject failed"
        $to         = $tofail
        $cc         = $ccfail
    }
    Write-Verbose "TO: $to FROM: $from CC:$CC SMTP: $smtp Subject: $subject Body: $body" 
    Send-MailMessage -From $from -To $to -Cc $cc  -Subject $subject -Body $body -SmtpServer $smtp

}

# Export-fnIncompleteOrder  -Verbose