function Get-fnForestDomainContoller {
    [CmdletBinding()]
    param()
    
    return @(Get-ADDomainController -Filter * | Select-Object Domain, Forest, Hostname)
}
