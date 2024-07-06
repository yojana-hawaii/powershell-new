
function Get-fnDomainClaimType {
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Claim Type"
        return Get-ADClaimType -Filter *
    } catch {
        Write-Error "Failed Get-fnDomainClaimType: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainClaimType -Verbose
