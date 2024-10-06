function Get-fnGpoXmlLinkTo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object] $xmlLinksTo
    )
    
    # Links count and related OU of each GPO
    if($xmlLinksTo){
        $linkSplit = ([Array] $xmlLinksTo).Where( { $_.Enabled -eq $true }, 'split')

        $linked = $linksEnabledCount -gt 0
        $linksEnabledCount = ([Array] $linkSplit[0]).Count
        $linksDisabledCount = ([Array] $linkSplit[1]).Count
        $linksTotalCount = ([array] $xmlLinksTo).Count
        
        $links = @(
            $xmlLinksTo | ForEach-Object -Process {
                if($_){
                    $_.SOMPath
                }
            }
        ) -join $splitter
        
        $linksObject = $xmlLinksTo | ForEach-Object -Process {
            if($_){
                [PSCustomObject]@{
                    ConanicalName   = $_.SOMPath
                    Enabled         = $_.Enabled
                    NoOverRide      = $_.NoOverRide 
                }   

            }
        }
        
    } else {
        $linked             = $false
        $linksEnabledCount  = 0
        $linksDisabledCount = 0
        $linksTotalCount    = 0
        $links              = $null
        $linksObject        = $null
    }

    return [PSCustomObject]@{
                Linked = $linked
                LinksEnabledCount   = $linksEnabledCount
                LinksDisabledCount  = $linksDisabledCount
                LinksTotalCount     = $linksTotalCount
                Links               = $links
                LinksObject         = $linksObject
            }
}