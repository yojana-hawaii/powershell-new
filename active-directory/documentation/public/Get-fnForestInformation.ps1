function Get-fnForestInformation {
    [CmdletBinding()]
    param()

    # $PSDefaultValues = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent

    $forest = Get-fnForest

    $data = [ordered]@{}
    $data.ForestRootDse             = Get-fnForestRootDse
    $data.ForestUpnSuffixes         = Get-fnForestUpnSuffixes -Forest $forest
    $data.ForestSpnSuffixes         = Get-fnForestSpnSuffixes -Forest $forest
    $data.ForestGlobalCatalogs      = $forest.GlobalCatalogs
    $data.ForestFSMO                = Get-fnForestFSMO -Forest $forest
    $data.ForestSubnets             = Get-fnForestSubets
    $data.ForestSiteLinks           = Get-fnForestSiteLinks
    $data.ForestInformation         = Get-fnForestDetails -Forest $forest -rootDSE $data.ForestRootDse


    $data.ForestOptionalFeatures    = Get-fnForestOptionalFeatures
    $data.ForestDomainControllers   = Get-fnForestDomainContoller
    
    $data.ForestSites               = Get-fnForestSites

    $data.ForestSchemaPropertiesComputers=''
    $data.ForestSchemaPropertiesUsers=''
    $data.ForestReplication=''

    return  $data



}
# Get-fnForestInformation -Verbose

