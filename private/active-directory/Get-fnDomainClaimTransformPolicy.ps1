
function Get-fnDomainClaimTransformPolicy {
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Claim TransformPolicy"
        return Get-ADClaimTransformPolicy -Filter *
    } catch {
        Write-Error "Failed Get-fnDomainClaimTransformPolicy: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainClaimTransformPolicy -Verbose