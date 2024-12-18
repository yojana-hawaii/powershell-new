function Initialize-fnOrderConfigs {
    [CmdletBinding()]
    param()
    Write-Verbose "Initializing the config files and create necessary PSCustomObjects in Initialize-fnOrderConfigs.ps1"
    $ffConfig           = Get-fnClinicalConfig
    $emailConfig        = Get-fnEmailConfig

    Write-Information "Get order path from config file. Strip `" (double quote) > Pulling path from config file adds double quotes everywhere  "
    $orderPath          = $ffConfig.orderPath
    $sourcePath         = Join-Path -Path $orderPath -ChildPath $ffConfig.sourcePath
    $referencesPath     = Join-Path -Path $orderPath -ChildPath $ffConfig.references
    
    $deletedBucket      = (($ffConfig.delete) -replace '"',"").Split(",")
    $group              = (($ffConfig.group) -replace '"',"").Split(",")

    $emailName          = ($ffConfig.emailSig) -replace '"',""
    
    Write-Information "Create PSCustomObject for labs, referrals and imaging orders."
    $labHash = [PSCustomObject]@{
        type            = "Labs"
        source          = (Join-Path -Path $sourcePath -ChildPath $ffConfig.labFileName) -replace '"',""
        alarm           = (($ffConfig.labAlarm) -replace '"',"").Split(",")
        delete          = $deletedBucket
        exclude         = (($ffConfig.exclude) -replace '"',"").Split(",")
        internalList    = (Join-Path -Path $referencesPath -ChildPath $ffConfig.internalLab) -replace '"',""
        
        summaryGroup    = $group[1]
        extSummary      = ""
        intSummary      = ""
        deletegroup     = $group[2]
        deletedata      = ""
        internalgroup   = $group[1]
        internaldata    = ""
        externalgroup   = $group[0]
        externaldata    = ""

        extDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.externalLabDest) -replace '"',""
        intDestination  = (Join-path -Path $orderPath -ChildPath $ffConfig.internalLabDest) -replace '"',""
        delDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.deleteDest) -replace '"',""
    }

    $consultHash = [PSCustomObject]@{
        type            = "Consult"
        source          = (Join-Path -Path $sourcePath -ChildPath $ffConfig.consultFileName) -replace '"',""
        alarm           = (($ffConfig.consultAlarm) -replace '"',"").Split(",")
        delete          = $deletedBucket
        exclude         = (($ffConfig.exclude) -replace '"',"").Split(",")
        internalList    = (Join-Path -Path $referencesPath -ChildPath $ffConfig.internalConsult) -replace '"',""
        
        summaryGroup    = $group[1]
        extSummary      = ""
        intSummary      = ""
        deletegroup     = $group[2]
        deletedata      = ""
        internalgroup   = $group[3]
        internaldata    = ""
        externalgroup   = $group[0]
        externaldata    = ""

        extDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.externalConsultDest) -replace '"',""
        intDestination  = (Join-path -Path $orderPath -ChildPath $ffConfig.internalConsultDest) -replace '"',""
        delDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.deleteDest) -replace '"',""
    }
    $imagingHash = [PSCustomObject]@{
        type            = "Imaging"
        source          = (Join-Path -Path $sourcePath  -ChildPath $ffConfig.imagingFileName) -replace '"',""
        alarm           = (($ffConfig.imagingAlarm) -replace '"',"").Split(",")
        delete          = $deletedBucket
        exclude         = (($ffConfig.exclude) -replace '"',"").Split(",")
        internalList    = (Join-Path -Path $referencesPath -ChildPath $ffConfig.internalImaging) -replace '"',""
        
        summaryGroup    = $group[1]
        extSummary      = ""
        intSummary      = ""
        deletegroup     = $group[2]
        deletedata      = ""
        internalgroup   = $group[1]
        internaldata    = ""
        externalgroup   = $group[0]
        externaldata    = ""

        extDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.externalImagingDest) -replace '"',""
        intDestination  = (Join-path -Path $orderPath -ChildPath $ffConfig.internalImagingDest) -replace '"',""
        delDestination  = (Join-Path -Path $orderPath -ChildPath $ffConfig.deleteDest) -replace '"',""
    }

    

    return @($labHash, $consultHash, $imagingHash)
}