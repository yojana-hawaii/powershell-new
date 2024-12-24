function Export-fnGroupedObjectToSeparateCsv {
    [CmdletBinding()]
    param (
        [parameter()]
        [System.Object]$groupObject,
        [parameter()]
        [string]$destination
    )

    Write-Verbose "Created CSV file for each group in Export-fnGroupedObjectToSeparateCsv"
    Write-Information "Removing old files from $destination."
    Remove-Item -Path (Join-Path -Path $destination -ChildPath "*") -Force
    try{
        foreach($object in $groupObject){
            $filename = "$((($object.Name -replace ", ", "_") -replace " ","_") -replace "/","_")_$($object.count)_open.csv"
            $filepath = (Join-Path -Path $destination -ChildPath $filename) -replace '"',""
            
            Write-Information "Creating file $filepath"
            ($object.Group) | Select-Object Name,AthenaPID,`DocumentID,PerformDate,Bucket,OrderProvider,Order,CurrentStatus,`
                                @{Name="ServiceProvider"; Expression={Convert-fnExternalServiceProvider -serviceProvider $_."sendto provdr"}}`
                                | Export-csv -Path $filepath -NoTypeInformation
        }
    }catch{
        Write-Warning "Export-fnGroupedObjectToSeparateCsv failed: $($_.Exception.Message)"
    }
}