

function Get-fnDomainCentralAccessRule {
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Central Access Rule"
        return Get-ADCentralAccessRule -Filter *
    } catch {
        Write-Error "Failed Get-fnDomainCentralAccessRule: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainCentralAccessRule -Verbose