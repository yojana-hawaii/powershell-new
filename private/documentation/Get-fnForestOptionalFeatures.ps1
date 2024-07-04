function Get-fnForestOptionalFeatures {
    [CmdletBinding()]
    param()
    return @(
        foreach($feature in Get-ADOptionalFeature -Filter *){
            $feature.Name
        }
    )
}