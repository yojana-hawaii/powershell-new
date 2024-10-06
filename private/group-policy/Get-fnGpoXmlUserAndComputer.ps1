function Get-fnGpoXmlUserAndComputer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$gpoExtension
    )
    $enabled            = $gpoExtension.Enabled
    $settingsNotNull    = -not($null -eq $gpoExtension.ExtensionData)
    
    foreach($extensionType in $gpoExtension.ExtensionData.Extension){
        if($extensionType){
            $gpoExtensionTypeSplit = $extensionType.type -split ':' # q1:RegistrySetting split
            try{
                $keys = $extensionType | Get-Member -MemberType Properties -ErrorAction Stop | Where-Object { $_.Name -notin 'type', $gpoExtensionTypeSplit[0] -and $_.Name -notin @('Blocked') }
            } catch {
                Write-Warning "Get-fnParsedGPOXml error on [$DisplayName]: $($_.Exception.Message)"
                continue
            }
        }
    }
    
    return [PSCustomObject]@{
        Enabled             = $enabled
        SettingNotFull      = $settingsNotNull
        Problem             = $settingsNotNull -and -not $enabled
        Optimized           = $settingsNotNull -xor $enabled
        SettingsType        = $keys.Name -join ", "
        SettingsAvailable   = $keys.count -gt 0
    } 
}