function Export-fnGroupObjectToSeparateCsv {
    [CmdletBinding()]
    param (
        [parameter()]
        [array]$GroupedObject
    )
    
    $allFilesCreatedSuccessfully = $false

    try {
        foreach($object in $GroupedObject){
            Write-Verbose "Create csv file for $($object.Name)"
            $filename = "$(($object.Name -replace ", ", "_") -replace " ","_")_$($object.count)_open.csv"
            $filepath = (Join-Path -Path $config.labFileDestination -ChildPath $filename) -replace '"',""
    
            ($object.Group) | Select-Object Name,AthenaPID,`DocumentID,PerformDate,Bucket,OrderProvider,Lab,CurrentStatus,`
                                @{Name="LabService"; Expression={Convert-fnLabService -LabService $_."sendto provdr"}}`
                                | Export-csv -Path $filepath -NoTypeInformation
        }
        $allFilesCreatedSuccessfully = $true
    } catch {
        Write-Warning "Export-fnGroupObjectToSeparateCsv failed: $($_.Exception.Message)"
    } 
    return $allFilesCreatedSuccessfully
}