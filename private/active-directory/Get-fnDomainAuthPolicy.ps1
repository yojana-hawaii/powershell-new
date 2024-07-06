function Get-fnDomainAuthPolicy{
    [CmdletBinding()]
    param()

    try{
        Write-Verbose "Getting Domain Authentication Policy"
        return Get-ADAuthenticationPolicy -LDAPFilter '(name=AuthenticationPolicy*)'
    } catch {
        Write-Error "Failed Get-fnDomainAuthPolicy: $($_.Exception.Message)"
        continue
    }
}

# Get-fnDomainAuthPolicy -Verbose