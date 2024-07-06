

function Get-fnDomainCentralAccessPolicy {
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Central Access Policy"
        return Get-ADCentralAccessPolicy -Filter *
    } catch {
        Write-Error "Failed Get-fnDomainCentralAccessPolicy: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainCentralAccessPolicy -Verbose