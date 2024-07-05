function Get-fnOptionalFeatures {
    [CmdletBinding()]
    param()

    try {
        Write-Verbose "Getting Optional Features"
        return @(
        foreach($feature in Get-ADOptionalFeature -Filter *){
            $feature.Name
        }
    )
     } catch {
         Write-Warning "Get-fnOptionalFeatures failed: $($_.Exception.Message) "
         continue
     }
}

# Get-fnOptionalFeatures -Verbose