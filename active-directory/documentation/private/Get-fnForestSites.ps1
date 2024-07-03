function Get-fnForestSites {
    return [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
}