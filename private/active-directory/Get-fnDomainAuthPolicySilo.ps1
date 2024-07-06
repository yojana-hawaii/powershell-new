function Get-fnDomainAuthPolicySilo {
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Authentication Policy Silo"
        return Get-ADAuthenticationPolicySilo -Filter '(name -like "AuthenticationPolicySilo*")'
    } catch {
        Write-Error "Failed Get-fnDomainAuthPolicySilo: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainAuthPolicySilo -Verbose